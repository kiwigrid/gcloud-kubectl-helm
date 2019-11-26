FROM google/cloud-sdk:272.0.0-alpine

ENV HELM_VERSION v2.16.1
ENV SOPS_VERSION v3.5.0
ENV YQ_BIN_VERSION 2.4.1

COPY entrypoint.sh entrypoint.sh
COPY commands.sh /data/commands.sh
COPY install.sh /tmp/install.sh

RUN chmod +x /tmp/install.sh && \
    /tmp/install.sh

VOLUME /data

USER gkh

RUN helm init --client-only && \ 
    helm plugin install https://github.com/monotek/helm-secrets.git

ENTRYPOINT ["/entrypoint.sh"]
