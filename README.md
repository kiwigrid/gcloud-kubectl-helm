# gcloud-kubectl-helm
Docker image for the quaternity of [gcloud](https://cloud.google.com/sdk/docs/), [helm](https://www.helm.sh), [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) and [SOPS](https://github.com/mozilla/sops).

[![Docker Pulls](https://img.shields.io/docker/pulls/kiwigrid/gcloud-kubectl-helm.svg?style=plastic)](https://hub.docker.com/r/kiwigrid/gcloud-kubectl-helm/)

- `latest` latest build from master
- `tag` releated git-tag (acutally the version of packed HELM client and gcloud, e.g. 2.10.0-217.0.0)

CircleCI status for Docker builds: [![CircleCI](https://circleci.com/gh/kiwigrid/gcloud-kubectl-helm.svg?style=svg)](https://circleci.com/gh/kiwigrid/gcloud-kubectl-helm)

# Usage

## With CGP Service Account and key file

Passing script with multiple commands
```bash
docker run -v /path/to/your/script.sh:/data/commands.sh:ro kiwigrid/gcloud-kubectl-helm
```

Passing script and GCP key-file
```bash
docker run -v /path/to/your/script.sh:/data/commands.sh:ro -volume /path/to/your/key-file.json:/data/gcp-key-file.json:ro kiwigrid/gcloud-kubectl-helm
```

## Interactive usage with your personal GCP Account

```bash
docker run -ti -v /path/to/your/workspace:/data/ kiwigrid/gcloud-kubectl-helm bash
# authenticate and paste token
$ gcloud auth application-default login

# setup kubectl context
$ gcloud container clusters get-credentials

# run helm
$ helm install release /data/your/chart -f values.yaml
# or with sops encrypted secrets file
$ helm secrets install release /data/your/chart -f values.yaml -f secrets.myapp.yaml
```

## CI/CD context
Using this image from a CI/CD pipeline is very handy.
It's recommended to start the container at the beginning of your pipeline.
Afterwards one can pass single commands to running container.

```bash
CONTAINER_NAME=gkh-container
# Start container
docker run \
  --volume /path/to/your/workdir:/workspace:ro \
  --workdir /workspace
  --volume /path/to/your/gcp-key-file.json:/data/gcp-key-file.json:ro \
  --env GOOGLE_APPLICATION_CREDENTIALS=/data/gcp-key-file.json
  --rm \
  -t \
  --name $CONTAINER_NAME \
  kiwigrid/gcloud-kubectl-helm:latest /bin/bash

# Execute arbitrary commands
docker exec $CONTAINER_NAME gcloud auth activate-service-account --key-file=/data/gcp-key-file.json
docker exec $CONTAINER_NAME gcloud config set project my-gcp-project-id
docker exec $CONTAINER_NAME gcloud container clusters get-credentials my-gke-cluster --project my-gcp-project-id --zone my-gke-zone

docker exec $CONTAINER_NAME helm list
docker exec $CONTAINER_NAME gcloud deployment-manager deployments describe my-deployment

# Kill
docker kill $CONTAINER_NAME
```

## Command file examples

Authorize access to GCP with a service account and fetch credentials for running cluster
```bash
gcloud auth activate-service-account --key-file=/data/gcp-key-file.json
gcloud container clusters get-credentials <clusterName> --project <projectId> [--region=<region> | --zone=<zone>]

helm list
kubectl get pods --all-namespaces
```

## Import GPG Keys

To import public GPG keys from keyserver, add them space separated to GPG_PUB_KEYS env variable.

```bash
docker run -e GPG_PUB_KEYS=<key id>   kiwigrid/gcloud-kubectl-helm:latest
```

## Add distributed Helm Chart Repositories

To include adding of distributed helm chart repos, add REPO_YAML_URL as env variable.
E.g.

```bash
docker run -e REPO_YAML_URL=https://raw.githubusercontent.com/helm/hub/master/config/repo-values.yaml kiwigrid/gcloud-kubectl-helm:latest
```

# Credits
This repo is inspired by
* https://github.com/eversC/gcloud-k8s-helm
* https://github.com/lfaoro/gcloud-kubectl-helm
