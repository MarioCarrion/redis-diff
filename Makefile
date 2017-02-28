binary := bin/redis-diff

build: deps
	go build -o $(binary)

deps:
	go get gopkg.in/redis.v4
	go get github.com/stretchr/testify/assert

test:
	go test

clean:
	rm -f $(binary)

binary: build

docker_go_build: deps
	CGO_ENABLED=0 GOOS=linux go build \
							--ldflags="-s" -a -installsuffix cgo -o redis-diff ./go/src/github.com/zph/redis-diff

docker_build:
	docker build --tag zph/redis-diff:build --file ./Dockerfile .

docker_build_final: docker_build
	docker run --tty zph/redis-diff:build /bin/true && \
		docker cp `docker ps -q -n=1`:/redis-diff . && \
		chmod 755 ./redis-diff && \
		docker rm `docker ps -q -n=1` && \
		docker build --rm --tag zph/redis-diff --file ./Dockerfile.static .

docker_clean:
	docker rmi $$(docker images -f "dangling=true" -q)
