# EOL has comment to prevent erroneous whitespace in variables
IMAGE = dotnet-build#
DOCKER_HUB_USERNAME = joshkeegan#
IMAGE_URL = $(DOCKER_HUB_USERNAME)/$(IMAGE)#

.PHONY: clean
clean:
	rm -r artefacts || true
	mkdir artefacts

.PHONY: format
format:
	@docker run --rm \
		-v $(PWD):/check \
		mstruebing/editorconfig-checker && \
	echo "Editorconfig styles followed"

.PHONY: build
build:
	docker build --no-cache --pull -t $(IMAGE_URL):dev .

.PHONY: tag
tag: clean build get-version-number
	docker tag $(IMAGE_URL):dev $(IMAGE_URL):`cat artefacts/version`
	docker tag $(IMAGE_URL):dev $(IMAGE_URL):latest

.PHONY: get-version-number
get-version-number:
# Get the version number from the version of the base image
#	e.g. a base of mcr.microsoft.com/dotnet/core/sdk:2.2.203-stretch would have version number 2.2.203
	export MSYS_NO_PATHCONV=1 && \
		docker run \
			--rm \
			-v ${PWD}:/app:ro \
			jess/dockfmt:v0.3.3 \
			base \
			/app/Dockerfile \
		| awk 'NR > 1 { split($$1, a, ":"); split(a[2], b, "-"); printf "%s", b[1] }' \
		> artefacts/version

	echo `cat artefacts/version`

.PHONY: publish
publish:
	docker push $(IMAGE_URL):`cat artefacts/version`
	docker push $(IMAGE_URL):latest