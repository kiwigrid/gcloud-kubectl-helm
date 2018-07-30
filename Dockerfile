FROM google/cloud-sdk:206.0.0-alpine

ENV HELM_VERSION v2.9.1

RUN adduser -S gkh gkh

RUN apk update && apk add ca-certificates && apk add openssl && rm -rf /var/cache/apk/*
RUN gcloud components install kubectl -q --no-user-output-enabled
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh --version $HELM_VERSION

# Data
VOLUME /data
RUN mkdir -p /data
RUN chown gkh /data

COPY commands.sh /data/commands.sh
RUN chmod +x /data/commands.sh

USER gkh

RUN helm init --client-only

CMD ["/bin/sh", "/data/commands.sh"]