# gcloud-kubectl-helm
Docker image for the trinity of [gcloud](https://cloud.google.com/sdk/docs/), [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) and [helm](https://www.helm.sh).

[![Docker Pulls](https://img.shields.io/docker/pulls/kiwigrid/gcloud-kubectl-helm.svg?style=plastic)](https://hub.docker.com/r/kiwigrid/gcloud-kubectl-helm/)
[![Docker Automated build](https://img.shields.io/docker/automated/kiwigrid/gcloud-kubectl-helm.svg?style=plastic)](https://hub.docker.com/r/kiwigrid/gcloud-kubectl-helm/builds/)

- `latest` latest build from master
- `tag` releated git-tag (acutally the version of packed HELM client and gcloud, e.g. 2.10.0-217.0.0)

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

# Credits
This repo is inspired by
* https://github.com/eversC/gcloud-k8s-helm
* https://github.com/lfaoro/gcloud-kubectl-helm
