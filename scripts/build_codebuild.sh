#!/usr/bin/env bash

# build.sh
#
# This build the image to be used in the rest of the pipeline

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

test() {
	echo "----> Starting to run tests!"
	docker run --entrypoint bundle -e RACK_ENV="test" -e DATABASE_URL="${DB_CONNECTION_STRING}" kittens:${CODEBUILD_RESOLVED_SOURCE_VERSION} exec rspec
	echo "----> The tests had ended succesfully"
}

build() {
	# Build the docker image
	(
		cd ${APP_PATH}
		docker build --target prod -t kittens:prod_${CODEBUILD_RESOLVED_SOURCE_VERSION} .
	)
}
