FROM google/cloud-sdk:365.0.1-alpine

ENV HELM_VERSION v3.7.1
ENV HELM2_VERSION v2.17.0
ENV KUBEVAL_VERSION v0.16.1
ENV SOPS_VERSION v3.7.1
ENV YQ_BIN_VERSION v4.14.2

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
