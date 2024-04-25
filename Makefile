APP=$(shell basename $(shell git remote get-url origin))
REGESTRY=mykolakonovalenko
VERSION:=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=${shell dpkg --print-architecture}
IMAGE_TAG=$(shell docker images -q)


format:
	gofmt -s -w ./

lint:
	golint

test: 
	go test	-v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/mykola-konovalenko/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	docker stop $(shell docker ps -aq)
	docker rm $(shell docker ps -aq)
	docker rmi ${IMAGE_TAG}
	rm -rf kbot
		