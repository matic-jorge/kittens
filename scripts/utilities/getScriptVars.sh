#!/usr/bin/env bash

# utils/getScriptVars.sh
#
# This set the variables which will be imported in the rest of scripts

UTILITIES_PATH="$(
	cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1
	pwd -P
)"
SCRIPT_PATH="$(
	cd -- "${UTILITIES_PATH}/.." >/dev/null 2>&1
	pwd -P
)"
ROOT_PATH="$(
	cd -- "${SCRIPT_PATH}/../.." >/dev/null 2>&1
	pwd -P
)"
APP_PATH="$(
	cd -- "${SCRIPT_PATH}/.." >/dev/null 2>&1
	pwd -P
)"
TERRAFORM_PATH="$(
	cd -- "${APP_PATH}/terraform" >/dev/null 2>&1
	pwd -P
)"

# "Constants"
DOCKER_REPO_IMAGE="jbcjorge/kittens"
