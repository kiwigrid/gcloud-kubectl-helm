#!/bin/bash
#
# push docker image to dockerhub
#

set -o errexit
set -o pipefail

DOCKER_TAG="$(grep -E '(ENV HELM_VERSION|FROM google/cloud-sdk)' Dockerfile | sed -e 's#ENV\ HELM_VERSION v##' -e 's#FROM\ google/cloud-sdk:##' -e 's#alpine##' | awk '{print}' ORS='')"

echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:${DOCKER_TAG}"
docker push "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:latest"
