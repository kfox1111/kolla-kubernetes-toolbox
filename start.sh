#!/bin/bash
cd ~/kolla;
. .venv/bin/activate;
count=$(ls /etc/kolla | wc -l)
[ $count -eq 0 ] && cp -a etc/kolla/* /etc/kolla/ && tools/generate_passwords.py
count=$(ls /etc/kolla-kubernetes | wc -l)
[ $count -eq 0 ] && cp -a etc/kolla-kubernetes/kolla-kubernetes.yml /etc/kolla-kubernetes/ && ln -s /home/kolla/etc/kolla-kubernetes/service_resources.yml /etc/kolla-kubernetes/service_resources.yml

exec $@
