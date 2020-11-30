#!/bin/bash
# 
# https://medium.com/@kosta709/kubernetes-by-kubeadm-config-yamls-94e2ee11244
#

set -a

K8S_API_ENDPOINT=amd9
K8S_API_ENDPOINT_INTERNAL=amd9-int.cluster.local

K8S_VERSION=1.19.3
K8S_CLUSTER_NAME=amd

OUTPUT_DIR=$( realpath -m ./_clusters/${K8S_CLUSTER_NAME})
LOCAL_CERTS_DIR=${OUTPUT_DIR}/pki
KUBECONFIG=${OUTPUT_DIR}/kubeconfig

mkdir -p ${OUTPUT_DIR}

MASTER_SSH_ADDR_1=cbates@192.168.2.41
set +a

export KUBEADM_TOKEN=$(kubeadm token generate)

# populate variables
envsubst < kubeinit.tmpl.yaml > ${OUTPUT_DIR}/kubeinit.yaml

# Generate certs
kubeadm init phase certs

# Generate CA Cert Hash
export CA_CERT_HASH=$(openssl x509 -pubkey -in ${LOCAL_CERTS_DIR}/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* /sha256:/')

