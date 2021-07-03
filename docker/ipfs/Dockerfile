FROM golang:1.15.1-alpine AS build
WORKDIR /src
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && \
    apk add --no-cache bash git openssh
RUN git clone https://github.com/ipfs/go-ipfs.git
# COPY . .
# RUN go build -o /out/example .
# FROM scratch AS bin
# COPY --from=build /out/example /
