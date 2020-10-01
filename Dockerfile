FROM google/cloud-sdk:312.0.0-alpine

ENV HELM_VERSION v3.3.4
ENV HELM2_VERSION v2.16.12
ENV KUBEVAL_VERSION 0.15.0
ENV SOPS_VERSION v3.6.1
ENV YQ_BIN_VERSION 3.4.0

COPY entrypoint.sh entrypoint.sh
COPY commands.sh /data/commands.sh
COPY install.sh /tmp/install.sh
COPY helm-init.sh /tmp/helm-init.sh

RUN chmod +x /tmp/install.sh /tmp/helm-init.sh && \
    /tmp/install.sh

VOLUME /data

USER gkh

RUN /tmp/helm-init.sh

ENTRYPOINT ["/entrypoint.sh"]
