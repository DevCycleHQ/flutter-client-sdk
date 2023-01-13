#!/bin/bash
SHA="$(git rev-parse HEAD)"
DEVCYCLE_PROD_SLEUTH_API_TOKEN="$(aws secretsmanager get-secret-value --secret-id=DEVCYCLE_PROD_SLEUTH_API_TOKEN | jq -r .SecretString )"

# make sure we're able to track this deployment
if [[ -z "$DEVCYCLE_PROD_SLEUTH_API_TOKEN" ]]; then
    echo "Sleuth.io deployment tracking token not found. Aborting."
    exit 1
fi

dart pub publish

if [[ "$?" != 0 ]]; then
    echo "Publish failed. Aborting."
    exit 1
fi

curl -X POST \
    -d api_key=$DEVCYCLE_PROD_SLEUTH_API_TOKEN \
    -d environment=production \
    -d sha=$SHA https://app.sleuth.io/api/1/deployments/taplytics/flutter-client-sdk/register_deploy