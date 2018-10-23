FROM google/cloud-sdk:219.0.1-alpine

ENV HELM_VERSION v2.11.0
ENV SOPS_VERSION 3.1.1

RUN adduser -S gkh gkh && \ 
    apk update && apk add ca-certificates gnupg openssl && \
    rm -rf /var/cache/apk/* && \
    gcloud components install kubectl -q --no-user-output-enabled && \
    gcloud -q components install beta && \
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh --version $HELM_VERSION && \
    curl -L --output /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && \
    chmod 755 /usr/local/bin/sops && \
    mkdir -p /data && \
    chown gkh /data 

VOLUME /data

COPY commands.sh sops_decrypt.sh /data/
COPY entrypoint.sh entrypoint.sh

RUN chown gkh /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER gkh

RUN helm init --client-only && \
    git clone https://github.com/futuresimple/helm-secrets.git ~/helm-secrets-plugin && \
    helm plugin install ~/helm-secrets-plugin/

ENTRYPOINT ["/entrypoint.sh"]
