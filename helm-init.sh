#!/usr/bin/env bash

set -e
set -x

if helm version --client | grep -q 'SemVer:"v2';then
    helm init --client-only
else
    helm repo add stable https://kubernetes-charts.storage.googleapis.com
fi

helm plugin install https://github.com/jkroepke/helm-secrets --version v3.9.1
helm plugin install https://github.com/hayorov/helm-gcs.git --version 0.3.18
helm plugin install https://github.com/databus23/helm-diff --version 3.1.3
