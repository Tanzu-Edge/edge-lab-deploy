#!/bin/bash

for i in {0..10}; do
  VSPHERE_NETWORK=robo-site-${i}-dvs-tkg-guest \
  VSPHERE_FOLDER=/robo-site-${i}/vm \
  VSPHERE_DATASTORE=/robo-site-${i}/datastore/vsanDatastore \
  VSPHERE_RESOURCE_POOL=/robo-site-${i}/host/cluster/Resources \
  VSPHERE_DATACENTER=/robo-site-${i} \
  VSPHERE_TEMPLATE=/robo-site-${i}/vm/photon-3-kube-v1.18.6+vmware.1 \
  VSPHERE_HAPROXY_TEMPLATE=/robo-site-${i}/vm/photon-3-haproxy-v1.2.4+vmware.1 \
  tkg create cluster edge-${i} --plan=prod -w 6
done
