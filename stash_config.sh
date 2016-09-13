#!/bin/bash
if [ "x$1" == "x" ]; then
	echo "You must use argument 'push' or 'pull" >&2
        exit -1
fi
if [ "$x" == "pull" ]; then
	kubectl create secret generic kolla-config --from-file=globals.yml=/etc/kolla/globals.yml --from-file=passwords.yml=/etc/kolla/passwords.yml
elif [ "$x" == "push" ]; then
	kubectl get secret kolla-config -o json | jq -r '.data."passwords.yml"' | base64 -d > /etc/kolla/passwords.yml
	kubectl get secret kolla-config -o json | jq -r '.data."globals.yml"' | base64 -d > /etc/kolla/globals.yml
fi

