FROM golang:1.20.2

WORKDIR /usr/app

RUN  apt update \ 
    && apt install -y wget \
    && apt install -y tar \
    && apt install -y sqlite3 \
    && apt install -y build-essential \
    && apt install -y protobuf-compiler \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 \ 
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

RUN wget https://github.com/ktr0731/evans/releases/download/v0.10.11/evans_linux_amd64.tar.gz
RUN tar xvzf evans_linux_amd64.tar.gz
RUN mv evans /usr/local/bin
RUN rm -rf evans_linux_amd64.tar.gz

ENV PATH="$PATH:$(go env GOPATH)/bin"
ENV CGO_ENABLED=1

EXPOSE 50051

CMD evans -v && go run cmd/grpcServer/main.go
