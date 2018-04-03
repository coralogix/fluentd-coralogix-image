image_name := fluentd-coralogix-image
repo_name  := coralogixrepo

build:
	docker build \
		--tag $(repo_name)/$(image_name):latest \
		--build-arg VERSION=${VERSION:-${TRAVIS_TAG:-latest}} \
		./fluentd_coralogix_image

remove:
	docker image rm $(image_name)

push:
	docker push $(repo_name)/$(image_name):latest