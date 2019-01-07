#!/bin/bash
#
# build and push docker image
#

set -o errexit
set -o pipefail

if [ "${CIRCLECI}" == 'true' ] && [ -z "${CIRCLE_PULL_REQUEST}" ]; then
  HELM_VERSION="$(grep 'ENV HELM_VERSION' Dockerfile | sed -e 's/ENV HELM_VERSION v//')"
  GCLOUD_SDK_VERSION="$(grep google/cloud-sdk Dockerfile | sed -e 's#FROM\ google/cloud-sdk:##'  -e 's#-alpine##')"
  DOCKER_TAG="${HELM_VERSION}-${GCLOUD_SDK_VERSION}"

  # build image
  echo "Build Docker image with tag ${DOCKER_TAG} for DockerHubs ${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY} repo"
  docker build --pull --no-cache -t "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:latest" -t "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:${DOCKER_TAG}" .

  # push image to dockerhub
  echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
  docker push "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:${DOCKER_TAG}-${CIRCLE_BUILD_NUM}"
  docker push "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:latest"
else
  echo "skipped deploy as only master branch is deployed..."
fi
