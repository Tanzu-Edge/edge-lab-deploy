#!/bin/bash

for i in {0..10}; do
  echo "edge-${i}..."
  kubectx edge-${i}-admin@edge-${i}
  tmc cluster attach -g edge-lab -n edge-${i}
  kubectl apply -f k8s-attach-manifest.yaml
  kubectl apply -f tkg-extensions-v1.1.0/cert-manager
  echo "waiting for cert-manager..."
  sleep 30
  kubectl apply -f tkg-extensions-v1.1.0/ingress/contour/vsphere
  kubectl apply -f tkg-extensions-v1.1.0/logging/fluent-bit/vsphere
  sed "s/<TKG_CLUSTER_NAME>/edge-${i}/g" tkg-extensions-v1.1.0/logging/fluent-bit/vsphere/output/elasticsearch/04-fluent-bit-configmap.yaml > tkg-extensions-v1.1.0/logging/fluent-bit/vsphere/output/elasticsearch/04-fluent-bit-configmap-edge-${i}.yaml
  kubectl apply -f tkg-extensions-v1.1.0/logging/fluent-bit/vsphere/output/elasticsearch/04-fluent-bit-configmap-edge-${i}.yaml
  kubectl apply -f tkg-extensions-v1.1.0/logging/fluent-bit/vsphere/output/elasticsearch/05-fluent-bit-ds.yaml
done
