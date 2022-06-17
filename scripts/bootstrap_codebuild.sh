#!/usr/bin/env bash

# bootstrap_codebuild.sh
#
# This bootstrap the application to run on codebuild, creating the
# docker image

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

bootstrap() {
	# Add the 'docker/' resources to be ignored by docker
	echo "docker/" >${APP_PATH}/.dockerignore
	# Build the docker image
	(
		cd ${APP_PATH}
		docker build --target test -t kittens:${CODEBUILD_RESOLVED_SOURCE_VERSION} .
	)

	# Reset the DB for testing (if exists, is recreated, if not, is created)
	bundle exec rake db:reset
}

test() {
	(
		cd ${APP_PATH}
		bundle exec rspec
	)
}
