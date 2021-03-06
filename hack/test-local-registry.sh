#!/bin/bash

#
# This script launches the image registry pointing to the OpenShift master defined in
# the KUBECONFIG environment variable (and uses the current credentials as the client
# credentials). You may need to start your master with the internalRegistryHostname
# configuration variable set for some image stream calls to function properly.
#

source "$(dirname "${BASH_SOURCE}")/lib/init.sh"

os::build::setup_env

os::util::ensure::built_binary_exists 'dockerregistry'

url="${REGISTRY_OPENSHIFT_SERVER_ADDR:-localhost:5000}"
# find the first builder service account token
token="$(oc get $(oc get secrets -o name | grep builder-token | head -n 1) --template '{{ .data.token }}' | os::util::base64decode)"
echo
echo "Login with:"
echo "  docker login -p \"${token}\" -u user ${url}"
echo

REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY="${REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY:-/tmp/registry}" \
  REGISTRY_OPENSHIFT_SERVER_ADDR="${url}" \
	dockerregistry images/dockerregistry/config.yml
