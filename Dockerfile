FROM google/cloud-sdk:228.0.0-alpine

ENV HELM_VERSION v2.12.1
ENV SOPS_VERSION 3.2.0
ENV YQ_BIN_VERSION 2.2.0

VOLUME /data

COPY entrypoint.sh entrypoint.sh
COPY commands.sh /data/commands.sh

RUN adduser -S gkh gkh && \
    apk update && apk add ca-certificates gnupg openssl && \
    rm -rf /var/cache/apk/* && \
    gcloud components install kubectl -q --no-user-output-enabled && \
    gcloud -q components install beta && \
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh --version $HELM_VERSION && \
    curl --location --output /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && \
    chmod 755 /usr/local/bin/sops && \
    curl --location --output /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_BIN_VERSION}/yq_linux_amd64 && \
    chmod 755 /usr/local/bin/yq && \
    mkdir -p /data && \
    chown gkh /data && \
    chown gkh /entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    chown gkh /data/commands.sh && \
    chmod +x /data/commands.sh

USER gkh

RUN helm init --client-only && \
    helm plugin install https://github.com/futuresimple/helm-secrets.git

ENTRYPOINT ["/entrypoint.sh"]
