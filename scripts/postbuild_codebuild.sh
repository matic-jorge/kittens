#!/usr/bin/env bash

# bootstrap_codebuild.sh
#
# This creates the image which will be used in the test environment (Heroku)

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

postbuild() {
	echo "Starting codebuild post build"
	# Get the current branch
	GIT_BRANCH=$(git symbolic-ref HEAD --short 2>/dev/null || true)
	if [ "$GIT_BRANCH" == "" ]; then
		GIT_BRANCH=$(git branch -a --contains HEAD | sed -n 2p | sed -e 's/[[:space:]]//g' | rev | cut -d/ -f1 | rev)
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

	# Release the image to heroku
	DOCKER_IMAGE_ID=$(docker inspect kittens:prod_${CODEBUILD_RESOLVED_SOURCE_VERSION} --format={{.Id}})
	curl -u ${HEROKU_EMAIL}:${HEROKU_API_KEY} \
		-H "Content-Type: application/json" \
		-H "Accept: application/vnd.heroku+json; version=3.docker-releases" \
		-X PATCH https://api.heroku.com/apps/jmillan-kittens-test/formation \
		-d '{"updates":[{"type":"web","docker_image":"'${DOCKER_IMAGE_ID}'"}]}'
}
