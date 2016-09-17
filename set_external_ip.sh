#!/bin/bash

if [ "x$1" == "x" ]; then
	echo "You must specify an ip." >&2
        exit -1
fi

IP=$1

echo "kolla_external_vip_address: '$IP'" >> /etc/kolla/globals.yml
sed -i "s/^\(kolla_external_vip_address:\).*/\1 '$IP'/" /etc/kolla/globals.yml
sed -i "s/^\(kolla_kubernetes_external_vip:\).*/\1 '$IP'/" /etc/kolla-kubernetes/kolla-kubernetes.yml

