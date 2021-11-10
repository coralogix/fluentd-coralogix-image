.PHONY:	all

PREFIX = coralogixrepo
IMAGE = fluentd-coralogix-image
TAG ?= $(or ${VERSION},${TRAVIS_TAG},1.0.0)

build:
	docker build \
		--tag $(PREFIX)/$(IMAGE):latest \
		--tag $(PREFIX)/$(IMAGE):$(TAG) \
		--build-arg VERSION=$(TAG) \
		./$(IMAGE)
build_push:
	docker buildx create --use --name mybuilder
	docker buildx build -t $(PREFIX)/$(IMAGE):latest --platform linux/arm64,linux/amd64 --push ./$(IMAGE)
	docker buildx rm mybuilder
