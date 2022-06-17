#!/usr/bin/env bash
set -e

# run.sh
#
# Run the kittens applications

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

PORT=${PORT:-4567}

(
	cd ${APP_PATH}
	bundle exec rackup --port ${PORT} --host 0.0.0.0
)
