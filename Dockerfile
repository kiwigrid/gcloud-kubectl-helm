FROM google/cloud-sdk:249.0.0-alpine

ENV HELM_VERSION v2.14.1
ENV SOPS_VERSION 3.3.0
ENV YQ_BIN_VERSION 2.3.0

COPY entrypoint.sh entrypoint.sh
COPY commands.sh /data/commands.sh
COPY install.sh /tmp/install.sh

RUN chmod +x /tmp/install.sh && \
    /tmp/install.sh

VOLUME /data

USER gkh

RUN helm init --client-only && \
    helm plugin install https://github.com/futuresimple/helm-secrets.git

ENTRYPOINT ["/entrypoint.sh"]
