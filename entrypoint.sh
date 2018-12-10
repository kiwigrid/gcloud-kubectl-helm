#!/bin/sh

if [ -n "${GPG_PUB_KEYS}" ]; then
  for KEY in ${GPG_PUB_KEYS}; do
    gpg --keyserver hkps.pool.sks-keyservers.net --recv ${KEY};
  done
fi

if [ -n "${REPO_YAML_URL}" ]; then
  REPO_YAML_PATH="/tmp/repo-values.yaml"
  curl --location --silent --show-error --output $REPO_YAML_PATH $REPO_YAML_URL 
  if [ -e $REPO_YAML_PATH ]; then  
    size=$(yq r $REPO_YAML_PATH 'sync.repos[*].name' | wc -l )
    index=$(expr $size - 1)
    for i in $(seq 0 $index); do 
      helm repo add $(yq r $REPO_YAML_PATH sync.repos[$i].name) $(yq r $REPO_YAML_PATH sync.repos[$i].url) ; 
    done
  else 
    echo "Download repo-values.yaml failed from URL ${REPO_YAML_URL}." 
  fi
fi 

if [ -n "${1}" ]; then
  ${1}
else
  sh /data/commands.sh
fi
