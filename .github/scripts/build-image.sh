#!/bin/bash
#
# build and push docker image
#

set -o errexit
set -o pipefail

HELM_VERSIONS="$(grep 'ENV HELM2_VERSION' Dockerfile | sed -e 's/ENV HELM2_VERSION v//') $(grep 'ENV HELM_VERSION' Dockerfile | sed -e 's/ENV HELM_VERSION v//')"
GCLOUD_SDK_VERSION="$(grep google/cloud-sdk Dockerfile | sed -e 's#FROM\ google/cloud-sdk:##'  -e 's#-alpine##')"
REPO_ROOT="$(git rev-parse --show-toplevel)"
IS_MASTER="false"
if [ "${GITHUB_REF}" == 'refs/heads/master' ]; then  IS_MASTER=true; fi

echo "DEBUG github environment: "
set | grep GITHUB

for HELM in ${HELM_VERSIONS}; do
  DOCKER_TAG="${HELM}-${GCLOUD_SDK_VERSION}-${GITHUB_RUN_NUMBER}"

  sed -i "s/get_helm.sh --version.*/get_helm.sh --version v${HELM}/" "${REPO_ROOT}"/install.sh

  # build image
  echo "Build Docker image with tag ${DOCKER_TAG} for DockerHubs ${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY} repo"

  if ! echo "${HELM}" | grep -q '^2.*'; then
    echo "DEBUG start build tag: 'latest'"
    docker build --pull --no-cache -t "${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY}:latest" -t "${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY}:${DOCKER_TAG}" .
    echo "DEBUG done build tag: 'latest'"
  else
    echo "DEBUG start build tag: '${DOCKER_TAG}'"
    docker build --pull --no-cache -t "${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY}:${DOCKER_TAG}" .
    echo "DEBUG done build tag: '${DOCKER_TAG}'"
  fi
  echo "DEBUG done all build Docker image with tag ${DOCKER_TAG} for DockerHubs ${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY} repo"

  echo "DEBUG: GITHUB_ACTIONS: ${GITHUB_ACTIONS} - IS_MASTER: ${IS_MASTER}"
  if [ "${GITHUB_ACTIONS}" == 'true' ] && [ ${IS_MASTER} == 'true' ]; then
    echo "DEBUG start pushing ${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY} repo"
    # push image to dockerhub
    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
    #  https://hub.docker.com/r/kiwigrid/gcloud-kubectl-helm
    #  https://docker.io/r/kiwigrid/gcloud-kubectl-helm
    docker push "${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY}:${DOCKER_TAG}"
    echo "DEBUG done pushing image ${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY}:${DOCKER_TAG}"

    if ! echo "${HELM}" | grep -q '^2.*'; then
      echo "DEBUG start pushing ${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY}:latest"
      docker push "${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY}:latest"
      echo "DEBUG done pushing ${DOCKER_REGISTRY}/${GITHUB_REPOSITORY_OWNER}/${DOCKER_REPOSITORY}:latest"
    fi
  else
    echo "skipped push as pull requests are not build..."
  fi
done
