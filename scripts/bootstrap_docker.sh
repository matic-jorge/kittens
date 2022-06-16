#!/usr/bin/env bash

# bootstrap_docker.sh
#
# Arguments
#		tmpdir		Directory to hold temporary files
#
# This runs the application inside docker

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

bootstrap() {
	TMP="${1}"
	if [ -z "${TMP}" ]; then
		TMP="${ROOT_PATH}/tmp"
	fi
	bundle config set --local path ${APP_PATH}
	bundle install
	if [ ! -f "${TMP}/.initialized" ]; then
		bundle exec rake db:create
		bundle exec rake db:migrate
		touch "${TMP}/.initialized"
	fi
}
