!/bin/bash
#
# build and push docker image
#

set -o errexit
set -o pipefail

HELM_VERSIONS="$(grep 'ENV HELM2_VERSION' Dockerfile | sed -e 's/ENV HELM2_VERSION v//') $(grep 'ENV HELM_VERSION' Dockerfile | sed -e 's/ENV HELM_VERSION v//')"
GCLOUD_SDK_VERSION="$(grep google/cloud-sdk Dockerfile | sed -e 's#FROM\ google/cloud-sdk:##'  -e 's#-alpine##')"
REPO_ROOT="$(git rev-parse --show-toplevel)"

for HELM in ${HELM_VERSIONS}; do
  DOCKER_TAG="${HELM}-${GCLOUD_SDK_VERSION}-${CIRCLE_BUILD_NUM}"

  sed -i "s/get_helm.sh --version.*/get_helm.sh --version v${HELM}/" "${REPO_ROOT}"/install.sh

  # build image
  echo "Build Docker image with tag ${DOCKER_TAG} for DockerHubs ${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY} repo"
  
  if ! echo "${HELM}" | grep -q '^2.*'; then
    docker build --pull --no-cache -t "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:${DOCKER_TAG}" .
  else
    docker build --pull --no-cache -t "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:latest" -t "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:${DOCKER_TAG}" .
  fi

  if [ "${CIRCLECI}" == 'true' ] && [ -z "${CIRCLE_PULL_REQUEST}" ]; then
    # push image to dockerhub
    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
    docker push "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:${DOCKER_TAG}"

    if ! echo "${HELM}" | grep -q '^2.*'; then
      docker push "${DOCKER_REGISTRY}/${GITHUB_USERNAME}/${DOCKER_REPOSITORY}:latest"
    fi
  else
    echo "skipped push as pull requests are not build..."
  fi
done