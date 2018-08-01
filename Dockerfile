FROM google/cloud-sdk:206.0.0-alpine

ENV HELM_VERSION v2.9.1
ENV SOPS_VERSION 3.0.5

RUN adduser -S gkh gkh

RUN apk update && apk add ca-certificates openssl && rm -rf /var/cache/apk/*
RUN gcloud components install kubectl -q --no-user-output-enabled
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh --version $HELM_VERSION

RUN curl -L --output /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && chmod 755  /usr/local/bin/sops 

# Data
RUN mkdir -p /data
RUN chown gkh /data
VOLUME /data

COPY commands.sh /data/commands.sh
RUN chmod +x /data/commands.sh

USER gkh

RUN helm init --client-only

RUN git clone  https://github.com/mhyllander/helm-secrets.git -b fixes ~/helm-secrets-plugin
RUN helm plugin install ~/helm-secrets-plugin/

CMD ["/bin/sh", "/data/commands.sh"]


