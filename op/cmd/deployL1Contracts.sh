#!/usr/bin/env bash

# This script is used to generate the getting-started.json configuration file
# used in the Getting Started quickstart guide on the docs site. Avoids the
# need to have the getting-started.json committed to the repo since it's an
# invalid JSON file when not filled in, which is annoying.

. ../cli/show.sh

reqenv() {
  if [ -z "${!1}" ]; then
    echo "Error: environment variable '$1' is undefined"
    exit 1
  fi
}

# Check required environment variables
reqenv "GS_ADMIN_PRIVATE_KEY"
reqenv "L1_RPC_URL"

text "Deploy Smart Contract To L1 ...   "
forge script scripts/Deploy.s.sol:Deploy --private-key $GS_ADMIN_PRIVATE_KEY --broadcast --rpc-url $L1_RPC_URL >> ${logfile}_config 2>&1
text "Ok" 1

text "Sync Smart Contract Info From L1 ...   "
forge script scripts/Deploy.s.sol:Deploy --sig 'sync()' --rpc-url $L1_RPC_URL >> ${logfile}_config 2>&1
text "Ok" 1
