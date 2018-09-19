FROM google/cloud-sdk:217.0.0-alpine

ENV HELM_VERSION v2.10.0
ENV SOPS_VERSION 3.0.5

RUN adduser -S gkh gkh

RUN apk update && apk add ca-certificates gnupg openssl && rm -rf /var/cache/apk/*
RUN gcloud components install kubectl -q --no-user-output-enabled
RUN gcloud -q components install beta
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh --version $HELM_VERSION

RUN curl -L --output /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && chmod 755  /usr/local/bin/sops

# Data
RUN mkdir -p /data
RUN chown gkh /data
VOLUME /data

COPY commands.sh sops_decrypt.sh /data/
COPY entrypoint.sh entrypoint.sh
RUN chown gkh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER gkh

RUN helm init --client-only
RUN git clone  https://github.com/futuresimple/helm-secrets.git ~/helm-secrets-plugin
# see https://github.com/futuresimple/helm-secrets/issues/52 and https://github.com/futuresimple/helm-secrets/pull/60
RUN cd ~/helm-secrets-plugin && git fetch origin pull/60/head:pr-60 &&  git checkout pr-60 && cd ..
RUN helm plugin install ~/helm-secrets-plugin/

ENTRYPOINT ["/entrypoint.sh"]
