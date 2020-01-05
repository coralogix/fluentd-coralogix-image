.PHONY:	publish

PREFIX = coralogixrepo
IMAGE = fluentd-coralogix-image
TAG ?= $(or ${VERSION},${TRAVIS_TAG},1.0.0)

build:
	docker build \
		--tag $(PREFIX)/$(IMAGE):latest \
		--tag $(PREFIX)/$(IMAGE):$(TAG) \
		--build-arg VERSION=$(TAG) \
		./$(IMAGE)

push:
	docker push $(PREFIX)/$(IMAGE):latest
	docker push $(PREFIX)/$(IMAGE):$(TAG)

publish: build push
