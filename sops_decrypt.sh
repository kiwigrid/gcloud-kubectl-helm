#!/bin/bash
#
# simple wrapper for 
#
#   sops -d file.yaml > dec.yaml
# 
# but without output redirection so that in can be called easily via inside docker exec
# E.g.
#
#  docker exec -t container bash sops_decrypt.sh file.yaml dec.yaml

function usage() {
  cat <<EOF

Usage: $0 path/to/secrets.yaml  path/for/decrypted.yaml

EOF
}

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    usage
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "No such file: $1"
    exit 1
fi
sops --decrypt $1 > $2

