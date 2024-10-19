#!/usr/bin/env bash

set -o pipefail

# Resolve to full paths
CONFIG_ABS_PATH="$(readlink -f "${INPUT_CONFIG_FILE}")"
CREDS_ABS_PATH="$(readlink -f "${INPUT_CREDS_FILE}")"
ALLOW_FETCH="${ALLOW_FETCH:-false}"
DISABLE_ORDERED_UPDATE="${DISABLE_ORDERED_UPDATE:-false}"
ENABLE_COLORS="${ENABLE_COLORS:-false}"
ENABLE_CONCURRENT="${ENABLE_CONCURRENT:-true}"

WORKING_DIR="$(dirname "${CONFIG_ABS_PATH}")"
cd "$WORKING_DIR" || exit
ARGS=()

if [ "$ENABLE_COLORS" = false ]; then
  ARGS+=(--no-colors)
fi

if [ "$DISABLE_ORDERED_UPDATE" = true ]; then
  ARGS+=(--disableordering)
fi

if [ "$ALLOW_FETCH" = true ]; then
  ARGS+=(--allow-fetch)
fi

if [ "$1" != "check"]; then
  if [ "$ENABLE_CONCURRENT" = true ]; then
    ARGS+=(--cmode concurrent)
  elif [ "$ENABLE_CONCURRENT" = true ]; then
    ARGS+=(--cmode legacy)
  fi
fi

ARGS+=(
  "$@"
  --config "$CONFIG_ABS_PATH"
)

# 'check' sub-command doesn't require credentials
if [ "$1" != "check" ]; then
  ARGS+=(--creds "$CREDS_ABS_PATH")
fi

OUTPUT="$(dnscontrol "${ARGS[@]}")"
EXIT_CODE="$?"

echo "$OUTPUT"

# Filter output to reduce 'preview' PR comment length
FILTERED_OUTPUT="$(echo "$OUTPUT" | /filter-preview-output.sh)"

# Set output
# https://github.com/orgs/community/discussions/26288#discussioncomment-3876281
DELIMITER="DNSCONTROL-$RANDOM"

{
  echo "output<<$DELIMITER"
  echo "$OUTPUT"
  echo "$DELIMITER"

  echo "preview_comment<<$DELIMITER"
  echo "$FILTERED_OUTPUT"
  echo "$DELIMITER"
} >>"$GITHUB_OUTPUT"

exit $EXIT_CODE
