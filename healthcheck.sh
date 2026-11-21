#!/bin/sh

# Checks anonymity by asking the Tor Project's check API, through Privoxy,
# whether the request arrived from a Tor exit. Exits non-zero if not.

# --max-time stays under the HEALTHCHECK --timeout, so a slow request
# fails here with a message rather than being killed silently.
if ! response=$(
  curl \
    --fail \
    --silent \
    --show-error \
    --connect-timeout 6 \
    --max-time 9 \
    --proxy localhost:8118 \
    --header "Accept: application/json" \
    https://check.torproject.org/api/ip 2>&1
); then
  echo "Anonymity check failed: ${response}"
  exit 1
fi

# /bin/sh is BusyBox ash, whose [[ ]] has no =~ operator.
if ! printf '%s' "$response" | grep -Eq '"IsTor" *: *true'; then
  echo "Anonymity check failed: ${response}"
  exit 1
fi

echo "Anonymity check succeeded: ${response}"
