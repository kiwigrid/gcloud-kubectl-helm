#!/usr/bin/env bash

set -e
set -x

if helm version --client | grep -q 'SemVer:"v2';then
    helm init --client-only
else
    helm repo add stable https://charts.helm.sh/stable
fi

helm plugin install https://github.com/hayorov/helm-gcs.git --version 0.3.16
helm plugin install https://github.com/databus23/helm-diff --version 3.1.3
