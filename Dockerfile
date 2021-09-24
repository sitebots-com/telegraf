FROM golang:alpine

RUN apk add --update git dep make alpine-sdk linux-headers

COPY ./gen.go /code/gen.go

ONBUILD RUN git clone --depth 1 https://github.com/sitebots-com/telegraf /go/src/github.com/influxdata/telegraf
ONBUILD WORKDIR /go/src/github.com/influxdata/telegraf

ONBUILD RUN make deps

ONBUILD COPY telegraf /etc/telegraf
ONBUILD RUN mkdir /go/src/github.com/influxdata/telegraf/gen
ONBUILD RUN cp /code/gen.go /go/src/github.com/influxdata/telegraf/gen/gen.go
ONBUILD RUN go run ./gen/gen.go
ONBUILD RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ./cmd/telegraf
