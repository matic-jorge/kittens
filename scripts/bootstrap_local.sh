#!/usr/bin/env bash

# bootstrap_local.sh
#
# This checks docker is running and use the compose file
# to start the local development environment

getComposePath() {
	# Check if docker-compose is found
	DOCKER_COMPOSE_PATH="$(type -P docker-compose 2>/dev/null)"
	if [ -z "${DOCKER_COMPOSE_PATH}" ]; then
		# Check if docker command exists... and if compose subcommand exists
		DOCKER_PATH="$(type -P docker 2>/dev/null)"
		if [ -z "${DOCKER_PATH}" ]; then
			echo "Please install docker or set the PATH variable to a place where to find it!"
			exit 1
		fi
		${DOCKER_PATH} compose >/dev/null 2>&1
		if [ "$?" -ne "0" ]; then
			echo "Could not find a way to run the compose file. Please install docker, docker-compose or fix the PATH."
			exit 2
		fi
		echo "${DOCKER_PATH} compose"
		return
	fi
	echo ${DOCKER_COMPOSE_PATH}
	return
}

bootstrap() {
	COMPOSE="$(getComposePath)"
	${COMPOSE} up -d
}
