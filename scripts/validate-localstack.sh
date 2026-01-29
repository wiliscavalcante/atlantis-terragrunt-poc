#!/usr/bin/env bash
set -euo pipefail

ENDPOINT_URL="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
QUEUE_NAME="${VALIDATION_QUEUE_NAME:-poc-validation-queue}"

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-sa-east-1}"

attempts=0
max_attempts=15

until aws --endpoint-url="$ENDPOINT_URL" sqs list-queues >/dev/null 2>&1; do
  attempts=$((attempts + 1))
  if [ "$attempts" -ge "$max_attempts" ]; then
    echo "LocalStack not ready at $ENDPOINT_URL after $max_attempts attempts" >&2
    exit 1
  fi
  sleep 2
done

echo "LocalStack ready. Creating queue: $QUEUE_NAME"
aws --endpoint-url="$ENDPOINT_URL" sqs create-queue --queue-name "$QUEUE_NAME" >/dev/null

aws --endpoint-url="$ENDPOINT_URL" sqs list-queues
