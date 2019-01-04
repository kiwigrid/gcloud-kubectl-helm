#!/bin/bash
#
# build docker image
#

set -o errexit
set -o pipefail

env | sort

DOCKER_TAG="$(grep -E '(ENV HELM_VERSION|FROM google/cloud-sdk)' Dockerfile | sed -e 's#ENV\ HELM_VERSION v##' -e 's#FROM\ google/cloud-sdk:##' -e 's#alpine##' | awk '{print}' ORS='')"

echo "Build Docker image with tag ${DOCKER_TAG} for DockerHubs ${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY} repo"
docker build --pull --no-cache -t "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:latest" -t "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:${DOCKER_TAG}" .
