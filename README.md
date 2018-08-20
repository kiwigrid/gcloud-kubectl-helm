# gcloud-kubectl-helm
Docker image for the trinity of [gcloud](https://cloud.google.com/sdk/docs/), [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) and [helm](https://www.helm.sh).

# Usage with CGP Service Account and key file 

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

# Interactive usage with your personal GCP Account 

```
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

# Credits
This repo is inspired by
* https://github.com/eversC/gcloud-k8s-helm
* https://github.com/lfaoro/gcloud-kubectl-helm