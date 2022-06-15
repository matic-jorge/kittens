#!/usr/bin/env bash
set -e

# bootstrap.sh
#
# Bootstrap the environment. If is run in docker (local development)
# then it bootstrap the application to be run. If is run on the local
# machine then checks docker is available and runs the compose file.
# If the argument 'tier' is passed will bootstrap the remote environment.
#
# Arguments:
# 	tier			The tier to initialize, either aws_test or aws_prod.
#							If ommited the bootstrap would be done over the calculated
#							environment.

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

TERRAFORM_ENVIRONMENT=${1:-"false"}
if [ "${TERRAFORM_ENVIRONMENT}" != "false" ] && [ "${TERRAFORM_ENVIRONMENT}" != "aws_test" ] && [ "${TERRAFORM_ENVIRONMENT}" != "aws_prod" ]; then
	echo "Wrong argument passed, the possible values are 'aws_test', 'aws_prod' or ommit the argument."
	exit 20
fi

bootstrapFile="bootstrap_${TERRAFORM_ENVIRONMENT}.sh"
if [ "${TERRAFORM_ENVIRONMENT}" == "false" ]; then
	source ${SCRIPT_PATH}/utilities/getEnvironment.sh
	bootstrapFile=$(getStepAndEnvironment bootstrap)
fi
source ${SCRIPT_PATH}/${bootstrapFile}

# Call the bootstrap function
bootstrap
