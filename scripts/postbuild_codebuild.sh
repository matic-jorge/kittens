#!/usr/bin/env bash

# bootstrap_codebuild.sh
#
# This bootstrap the application to run on codebuild, creating the
# docker image

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

postbuild() {
	# Check if the branch is main
	if [ "$(git symbolic-ref --short HEAD)" != "main" ]; then
		# We do not intend to keep the artifact, finish the run successfully
		exit 0
	fi

	# Login to Heroku docker repository
	docker login --username=_ --password=${HEROKU_API_KEY} registry.heroku.com

	# Push to Heroku registry
	docker tag kittens:prod_${CODEBUILD_RESOLVED_SOURCE_VERSION} registry.heroku.com/jmillan-kittens-test/web
	docker push registry.heroku.com/jmillan-kittens-test/web
}
