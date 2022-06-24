#!/usr/bin/env bash

# bootstrap_codebuild.sh
#
# This bootstrap the application to run on codebuild, creating the
# docker image

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

postbuild() {
	echo "Starting codebuild post build"
	# Get the current branch
	GIT_BRANCH=$(git symbolic-ref HEAD --short 2>/dev/null)
	if [ "$GIT_BRANCH" == "" ]; then
		GIT_BRANCH=$(git branch -a --contains HEAD | sed -n 2p | rev | cut -d/ -f1 | rev)
	fi

	# Check if the branch is main
	if [ "${GIT_BRANCH}" != "main" ]; then
		# We do not intend to keep the artifact, finish the run successfully
		echo "As the branch is '${GIT_BRANCH}', we'll not push the image"
		exit 0
	fi

	# Login to Heroku docker repository
	docker login --username=_ --password=${HEROKU_API_KEY} registry.heroku.com

	# Push to Heroku registry
	docker tag kittens:prod_${CODEBUILD_RESOLVED_SOURCE_VERSION} registry.heroku.com/jmillan-kittens-test/web
	docker push registry.heroku.com/jmillan-kittens-test/web
}
