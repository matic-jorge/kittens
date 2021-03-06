#!/usr/bin/env bash
set -e

# build.sh
#
# Builds the image to use in the rest of the "pipeline"

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

source ${SCRIPT_PATH}/utilities/getEnvironment.sh
environment=$(getEnvironment)
postBuildFile=$(getStepAndEnvironment postbuild)
source ${SCRIPT_PATH}/${postBuildFile}

postbuild
