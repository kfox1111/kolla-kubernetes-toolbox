#!/bin/bash
cd ~/kolla;
. .venv/bin/activate;
count=$(ls /etc/kolla | wc -l)
[ $count -eq 0 ] && cp -a etc/kolla/* /etc/kolla/ && tools/generate_passwords.py
exec $@
