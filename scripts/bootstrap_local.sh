#!/usr/bin/env bash

# bootstrap_local.sh
#
# This checks docker is running and use the compose file
# to start the local development environment

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

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

getRepoVersion() {
	version=""
	# Check if the repository is "dirty"
	GS=$(git status --porcelain=v1 2>/dev/null)
	if [ "$?" -eq "128" ]; then
		echo "This is not a git repository!"
		exit 3
	fi
	if [ "$(echo "${GE}" | wc -l)" -ne "0" ]; then
		version="dirty"
	else
		version="$(git rev-parse --short --verified HEAD)"
	fi
	echo "${version}"
}

checkImageVersionLocally() {
	found="notFound"
	if [ "$(docker images -q ${DOCKER_REPO_IMAGE}:${version} | head -c1 | wc -c)" -ne "0" ]; then
		found="found"
	fi
	echo "${found}"
}

deleteDockerImage() {
	version=${1}
	echo "Deleting the version '${version}'"
	docker rmi -f ${DOCKER_REPO_IMAGE}:${version} >/dev/null 2>&1
}

createDockerImage() {
	version=${1}
	(
		cd ${APP_PATH}
		echo "Creating the version '${version}'"
		docker build --target local_compose -t ${DOCKER_REPO_IMAGE}:${version} .
	)
}

recreateDockerImage() {
	version=${1}
	if [ "$(checkImageVersionLocally ${version})" == "found" ]; then
		deleteDockerImage ${version}
	fi
	createDockerImage ${version}
}

bootstrap() {
	# Get how to invoke the compose binary
	COMPOSE="$(getComposePath)"

	# Get the current version of the git repository
	version=$(getRepoVersion)

	if [ "${version}" == "dirty" ]; then
		# If the version is "dirty" (meaning there's changes) re-create the docker image always (erasing the old one first)
		echo "Version is dirty, recreating the image"
		recreateDockerImage ${version}
	elif [ "$(checkImageVersionLocally ${version})" != "found" ]; then
		# Check if the current version is in the local image repository, if not, build
		createDockerImage ${version}
	fi

	(
		cd ${APP_PATH}
		export currentVersion=${version}
		echo "Using the version '${currentVersion}' of ${DOCKER_REPO_IMAGE}"
		${COMPOSE} up -d
	)
}
