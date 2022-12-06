FROM golang:latest

COPY ca.pem /usr/local/share/ca-certificates/ca.crt
RUN update-ca-certificates

WORKDIR /etc/peer

RUN curl -sSfL https://raw.githubusercontent.com/cosmtrek/air/master/install.sh | sh -s -- -b $(go env GOPATH)/bin

COPY main.go main.go
COPY go.mod go.mod
RUN go build .

CMD air