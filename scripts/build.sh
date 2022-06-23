#!/usr/bin/env bash
set -e

# build.sh
#
# Builds the image to use in the rest of the "pipeline"

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

source ${SCRIPT_PATH}/utilities/getEnvironment.sh
environment=$(getEnvironment)
buildFile=$(getStepAndEnvironment build)
source ${SCRIPT_PATH}/${buildFile}

# If environment is test... then test!
if [ "${environment}" == "test" ]; then
	if [ "$(type -t test)" != "function" ]; then
		echo "Function test can't be found... bailing out!"
		exit 30
	fi
	test
fi

# Call the build function
build
