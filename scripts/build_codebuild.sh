#!/usr/bin/env bash

# build.sh
#
# This build the image to be used in the rest of the pipeline

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

build() {
	# Build the docker image
	(
		cd ${APP_PATH}
		docker build -t kittens:${CODEBUILD_RESOLVED_SOURCE_VERSION} .
	)

	# Reset the DB for testing (if exists, is recreated, if not, is created)
	bundle exec rake db:reset
}
