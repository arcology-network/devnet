#!/usr/bin/env bash

# This script is used to generate the getting-started.json configuration file
# used in the Getting Started quickstart guide on the docs site. Avoids the
# need to have the getting-started.json committed to the repo since it's an
# invalid JSON file when not filled in, which is annoying.

reqenv() {
  if [ -z "${!1}" ]; then
    echo "Error: environment variable '$1' is undefined"
    exit 1
  fi
}

# Check required environment variables
reqenv "GS_ADMIN_ADDRESS"
reqenv "GS_ADMIN_PRIVATE_KEY"
reqenv "L1_CHAIN_ID"
reqenv "L2_CHAIN_ID"
reqenv "L1_RPC_URL"
reqenv "L2_RPC_URL"

# Generate the config file
config=$(cat << EOL
{
  "L1": {
     "url": "$L1_RPC_URL",
     "accounts": ["$GS_ADMIN_PRIVATE_KEY"],
     "addrs": ["$GS_ADMIN_ADDRESS"],
     "chainId": $L1_CHAIN_ID
   },
   "L2": {
     "url": "$L2_RPC_URL",
     "accounts": ["$GS_ADMIN_PRIVATE_KEY"],
     "addrs": ["$GS_ADMIN_ADDRESS"],
     "chainId": $L2_CHAIN_ID
   }
}
EOL
)

# Write the config file
echo "$config" > sdk/network.json
