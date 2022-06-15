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

	# Login to docker hub
	# TODO

	# Push to docker hub
	# TODO
}
