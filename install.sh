#!/usr/bin/env bash

set -e
set -x

adduser -S gkh gkh

apk update
apk add ca-certificates gnupg mysql-client openssl
rm -rf /var/cache/apk/*

gcloud components install -q beta cloud_sql_proxy kubectl

curl --silent --show-error --fail --location --output get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
chmod 700 get_helm.sh

./get_helm.sh --version "${HELM_VERSION}"

curl --silent --show-error --fail --location --output /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/"${SOPS_VERSION}"/sops-"${SOPS_VERSION}".linux
chmod 755 /usr/local/bin/sops

curl --silent --show-error --fail --location --output /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/"${YQ_BIN_VERSION}"/yq_linux_amd64
chmod 755 /usr/local/bin/yq

mkdir -p /data
chown gkh /data
chown gkh /entrypoint.sh
chmod +x /entrypoint.sh
chown gkh /data/commands.sh
chmod +x /data/commands.sh
