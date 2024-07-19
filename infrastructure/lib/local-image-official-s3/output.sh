#!/bin/bash

# Set the stack name
STACK_NAME="Orthanc-ECSStack"

# Retrieve the secret name from CloudFormation
ORTHANC_SECRET_NAME=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r '.Stacks | .[] | .Outputs[] | select(.OutputKey | test(".*OrthancCredentialsName.*")) | .OutputValue')

# Check if the secret name was retrieved successfully
if [ -z "$ORTHANC_SECRET_NAME" ]; then
  echo "Failed to retrieve the OrthancCredentialsName from CloudFormation."
  exit 1
fi

# Retrieve the secret value from Secrets Manager
ORTHANC_SECRET_VALUE=$(aws secretsmanager get-secret-value --secret-id "$ORTHANC_SECRET_NAME" | jq -r ".SecretString")

# Check if the secret value was retrieved successfully
if [ -z "$ORTHANC_SECRET_VALUE" ]; then
  echo "Failed to retrieve the secret value from Secrets Manager."
  exit 1
fi

# Retrieve the Orthanc URL from CloudFormation
ORTHANC_URL=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r '.Stacks | .[] | .Outputs[] | select(.OutputKey | test(".*OrthancURL.*")) | .OutputValue')

# Check if the Orthanc URL was retrieved successfully
if [ -z "$ORTHANC_URL" ]; then
  echo "Failed to retrieve the OrthancURL from CloudFormation."
  exit 1
fi

# Output the retrieved values
echo "Orthanc Credentials Name: $ORTHANC_SECRET_NAME"
echo "Orthanc Secret Value: $ORTHANC_SECRET_VALUE"
echo "Orthanc URL: $ORTHANC_URL"
