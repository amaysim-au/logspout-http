NAME=logspout-http
VERSION=$(shell cat VERSION)

dev:
	rm -rf ./tmp
	mkdir -p ./tmp/src
	cp -r ./vendor/src tmp/
	mkdir -p ./tmp/src/github.com/amaysim-au/logspout-http/http
	cp -r ./modules.go ./tmp/src/github.com/amaysim-au/logspout-http
	cp -r ./http/* ./tmp/src/github.com/amaysim-au/logspout-http/http
	cp ./tmp/src/github.com/amaysim-au/logspout-http/modules.go ./tmp/src/github.com/amaysim-au/logspout
	@docker build -f Dockerfile.dev -t $(NAME):dev .
	@docker run --rm \
		-e DEBUG=true \
		-e STATS=true \
		-e CRASH= \
		-e LOGSPOUT=ignore \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(PWD):/go/src/github.com/amaysim-au/logspout-http \
		-p 8000:80 \
		-e ROUTE_URIS="$(ROUTE)" \
		$(NAME):dev

build:
	mkdir -p build
	docker build -t $(NAME):$(VERSION) .
	docker save $(NAME):$(VERSION) | gzip -9 > build/$(NAME)_$(VERSION).tgz

.PHONY: release
