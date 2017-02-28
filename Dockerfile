# vim: set syntax=dockerfile:
FROM golang:1.7.4

COPY Makefile /
WORKDIR /

COPY ./ ./go/src/github.com/zph/redis-diff
RUN make docker_go_build

CMD ["/bin/bash"]
