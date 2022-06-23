#!/usr/bin/env bash
set -e

# bootstrap_aws_test.sh
#
# Depends:
#		- AWS CLI
#		- jq
#		- Terraform (tfenv is the preferred manager)
#
# This checks ensures the needed S3 bucket is up for the Terraform code to run,
# it depends on the AWS CLI to be installed and configured properly.

# Get the script variables
source "${BASH_SOURCE%/*}/utilities/getScriptVars.sh"

TERRAFORM_S3_BUCKET="kittens-test-terraform"
TERRAFORM_DYNAMODB_LOCK_TABLE="${TERRAFORM_S3_BUCKET}-lock"

# Check the AWS CLI binary is accesible
type -P aws >/dev/null 2>&1
if [ "$?" -ne "0" ]; then
	echo "Please make sure to install the AWS CLI"
	exit 1
fi

# Checks the 'jq' utility is present
type -P jq >/dev/null 2>&1
if [ "$?" -ne "0" ]; then
	echo "Please make sure to install the 'jq' utility"
	exit 2
fi

# Check if 'tfenv' is available (to handle "automagically" terraform)
type -P tfenv >/dev/null 2>&1
if [ "$?" -ne "0" ]; then
	additional_output=", 'tfenv' would be a better option"
	# Checks the 'terraform' utility is present
	type -P terraform >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		echo "Please make sure to install the 'terraform' utility${additional_output}"
		exit 3
	fi
	echo "'terraform binary found'${additional_output}"
fi

bootstrap() {
	# Checks the AWS CLI have the right access
	aws s3api list-buckets >/dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		echo "Please make sure to configure correctly the AWS CLI"
		exit 4
	fi

	# Check if the terraform bucket exists
	bucket_json=$(aws s3api list-buckets --query "Buckets[?Name=='${TERRAFORM_S3_BUCKET}'] | [0]")
	if [ "${bucket_json}" == "null" ]; then
		echo "Bucket doesn't exists, creating it!"
		aws s3api create-bucket --bucket "${TERRAFORM_S3_BUCKET}" --acl private >/dev/null 2>&1
		aws s3api wait bucket-exists --bucket "${TERRAFORM_S3_BUCKET}" >/dev/null 2>&1
	fi

	# Ensures the bucket versioning is present
	aws s3api put-bucket-versioning --bucket "${TERRAFORM_S3_BUCKET}" --versioning-configuration Status=Enabled >/dev/null 2>&1

	echo "*** Bucket exists!"

	# Check if the dynamo DB table exists
	dynamodb_json=$(aws dynamodb list-tables --query "TableNames[?contains(@, '${TERRAFORM_DYNAMODB_LOCK_TABLE}')] | [0]")
	if [ "${dynamodb_json}" == "null" ]; then
		echo "DynamoDB table doesn't exists, creating it!"
		aws dynamodb create-table --table-name "${TERRAFORM_DYNAMODB_LOCK_TABLE}" \
			--attribute-definitions AttributeName=LockID,AttributeType=S \
			--key-schema AttributeName=LockID,KeyType=HASH \
			--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 >/dev/null 2>&1
		aws dynamodb wait table-exists --table-name "${TERRAFORM_DYNAMODB_LOCK_TABLE}" >/dev/null 2>&1
	fi

	echo "*** DynamoDB lock table exists!"

	(
		cd terraform/test
		terraform init -upgrade
		terraform plan -var-file="${TERRAFORM_PATH}/secrets.tfvars" -var-file="${TERRAFORM_PATH}/variables.tfvars" -out /tmp/kittens.test.plan
		read -p 'Continue (Y/n): ' applyChanges
		if [ "${applyChanges,,}" != "y" ]; then
			echo "The script is not applying the changes, to apply respond 'Y'."
			exit 0
		fi
		terraform apply -auto-approve /tmp/kittens.test.plan
		dbConnectionString="$(terraform output -raw db_connection_string)"

		# Store the DB connection secret
		secretARN=$(aws secretsmanager list-secrets --filters Key=name,Values=test/dbConnectionString --query "SecretList | [0].ARN" --output text)
		if [ "${secretARN}" == "None" ]; then
			aws secretsmanager create-secret \
				--name test/dbConnectionString \
				--description "Connection string for test environment." \
				--secret-string "{\"dbConnectionString\":\"${dbConnectionString}\"}" >/dev/null 2>&1
		else
			aws secretsmanager update-secret \
				--secret-id ${secretARN} \
				--secret-string "{\"dbConnectionString\":\"${dbConnectionString}\"}" >/dev/null 2>&1
		fi

		# Store the docker login secret
		secretARN=$(aws secretsmanager list-secrets --filters Key=name,Values=common/dockerLogin --query "SecretList | [0].ARN" --output text)
		if [ "${secretARN}" == "None" ]; then
			aws secretsmanager create-secret \
				--name common/dockerLogin \
				--description "Login credentials for docker hub" \
				--secret-string "{\"user\":\"$(cat ${APP_PATH}/dockerLogin.ini | grep 'user' | sed 's/user=//g')\",\"password\":\"$(cat ${APP_PATH}/dockerLogin.ini | grep 'token' | sed 's/token=//g')\"}" >/dev/null 2>&1
		else
			aws secretsmanager update-secret \
				--secret-id ${secretARN} \
				--secret-string "{\"user\":\"$(cat ${APP_PATH}/dockerLogin.ini | grep 'user' | sed 's/user=//g')\",\"password\":\"$(cat ${APP_PATH}/dockerLogin.ini | grep 'token' | sed 's/token=//g')\"}" >/dev/null 2>&1
		fi

	)
}
