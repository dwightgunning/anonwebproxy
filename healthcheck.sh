#!/bin/sh

# Checks anonimity by making a request to the TOR check api. If the check fails, the script terminates with a non-zero code.

anonymity_check_response=$(
  curl \
    --no-progress-meter \
    --connect-timeout 6 \
    --max-time 12 \
    --proxy localhost:8118 \
    --header "Accept: application/json" \
    https://check.torproject.org/api/ip
)
anonymity_regex="^.*\"IsTor\":true.*$"

if [[ ! $anonymity_check_response =~ $anonymity_regex ]]; then
  echo "Anonymity check failed: ${anonymity_check_response}"
  exit 1
fi

echo "Anonymity check succeeded: ${anonymity_check_response}"
