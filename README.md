# gcloud-kubectl-helm
Docker image for the trinity of [gcloud](https://cloud.google.com/sdk/docs/), [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) and [helm](https://www.helm.sh).

[![Docker Pulls](https://img.shields.io/docker/pulls/kiwigrid/gcloud-kubectl-helm.svg?style=plastic)](https://hub.docker.com/r/kiwigrid/gcloud-kubectl-helm/)
[![Docker Automated build](https://img.shields.io/docker/automated/kiwigrid/gcloud-kubectl-helm.svg?style=plastic)](https://hub.docker.com/r/kiwigrid/gcloud-kubectl-helm/builds/)

- `latest` always corresponds with the latest build from master
- Docker `tag` always correspond with git `tag`

As version, the underlaying HELM version is used.

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


# Credits
This repo is inspired by
* https://github.com/eversC/gcloud-k8s-helm
* https://github.com/lfaoro/gcloud-kubectl-helm