#!/usr/bin/env bash

# utilities/get_environment.sh
#
# This is used to get the needed file to load/source, depending on the
# environment type.
#
# Arguments
# 	step		This is the step to put as "prefix", bootstrap, build or postbuild

getEnvironment() {
	ENVIRONMENT="local"
	if [ ! -z "${CODEBUILD_INITIATOR}" ]; then
		ENVIRONMENT="test"
	elif [ ! -z "${KITTENS_VERSION}" ]; then
		ENVIRONMENT="prod"
	fi

	echo "${ENVIRONMENT}"
}

getStepAndEnvironment() {
	STEP=${1:-"bootstrap"}
	ENVIRONMENT="local"

	if [ "${STEP}" != "bootstrap" ] && [ "${STEP}" != "build" ] && [ "${STEP}" != "postbuild" ]; then
		echo "The first argument (STEP) should be either bootstrap, build or postbuild. Bailing out!"
		exit 10
	fi

	# Check if we're in docker or not
	if [ "${IS_DOCKER}empty" == "empty" ]; then
		ENVIRONMENT="local"
	elif [ ! -z "${CODEBUILD_INITIATOR}" ]; then
		ENVIRONMENT="codebuild"
	else
		ENVIRONMENT="docker"
	fi

	echo "${STEP}_${ENVIRONMENT}.sh"
}
