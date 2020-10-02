#!/bin/bash

VCENTER_URL=pao-vc-01.rogue.pvd.pez.pivotal.io
VCENTER_USERNAME='administrator@vsphere.local'
VCENTER_DATASTORE=vsanDatastore
MGMT_DC_NAME=VxRail-Datacenter
EDGE_DC_PREFIX=robo-site
KUBE_TEMPLATE=photon-3-kube-v1.18.6+vmware.1
HAPROXY_TEMPLATE=photon-3-haproxy-v1.2.4+vmware.1

# use info from above if not already set in env
if [ -z "$GOVC_URL" ]; then
  export GOVC_URL=${VCENTER_URL}
fi
if [ -z "$GOVC_USERNAME" ]; then
  export GOVC_USERNAME=${VCENTER_USERNAME}
fi
if [ -z "$GOVC_PASSWORD" ]; then
  read -s -p "Password for ${GOVC_USERNAME} @ ${GOVC_URL} : " GOVC_PASSWORD
fi
export GOVC_INSECURE=true

for i in {0..10}; do
  govc vm.clone -template=true -dc=/${EDGE_DC_PREFIX}-${i} \
  -vm /${MGMT_DC_NAME}/vm/${KUBE_TEMPLATE} \
  -folder /${EDGE_DC_PREFIX}-${i}/vm/ -pool /${EDGE_DC_PREFIX}-${i}/host/cluster/Resources \
  -ds=/${EDGE_DC_PREFIX}-${i}/datastore/${VCENTER_DATASTORE} \
  -on=false ${KUBE_TEMPLATE}
  
  govc vm.clone -template=true -dc=/${EDGE_DC_PREFIX}-${i} \
  -vm /${MGMT_DC_NAME}/vm/${HAPROXY_TEMPLATE} \
  -folder /${EDGE_DC_PREFIX}-${i}/vm/ -pool /${EDGE_DC_PREFIX}-${i}/host/cluster/Resources \
  -ds=/${EDGE_DC_PREFIX}-${i}/datastore/${VCENTER_DATASTORE} \
  -on=false ${HAPROXY_TEMPLATE}
done
