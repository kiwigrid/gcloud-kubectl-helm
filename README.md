# gcloud-kubectl-helm
Docker image for the trinity of [gcloud](https://cloud.google.com/sdk/docs/), [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) and [helm](https://www.helm.sh).

[![Docker Pulls](https://img.shields.io/docker/pulls/kiwigrid/gcloud-kubectl-helm.svg?style=plastic)](https://hub.docker.com/r/kiwigrid/gcloud-kubectl-helm/)
[![Docker Automated build](https://img.shields.io/docker/automated/kiwigrid/gcloud-kubectl-helm.svg?style=plastic)](https://hub.docker.com/r/kiwigrid/gcloud-kubectl-helm/builds/)

- `latest` latest build from master
- `tag` releated git-tag (acutally the version of the packed HELM client)

# Usage

Executing single command
```
docker run kiwigrid/gcloud-kubectl-helm helm version -c
```

Passing script with multiple commands
```
docker run -v /path/to/your/script.sh:/data/commands.sh:ro kiwigrid/gcloud-kubectl-helm
```

Passing script and GCP key-file
```
docker run -v /path/to/your/script.sh:/data/commands.sh:ro -volume /path/to/your/key-file.json:/data/gcp-key-file.json:ro kiwigrid/gcloud-kubectl-helm
```

## Command file examples

Authorize access to GCP with a service account and fetch credentials for running cluster
```
gcloud auth activate-service-account --key-file=/data/gcp-key-file.json
gcloud container clusters get-credentials <clusterName> --project <projectId> [--region=<region> | --zone=<zone>]

helm list
kubectl get pods --all-namespaces
```

# Credits
This repo is inspired by
* https://github.com/eversC/gcloud-k8s-helm
* https://github.com/lfaoro/gcloud-kubectl-helm