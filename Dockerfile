FROM centos:centos7
MAINTAINER Kevin Fox "Kevin.Fox@pnnl.gov"

RUN \
  rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
  yum install -y git ansible python-virtualenv python-devel gcc; \
  adduser kolla;

RUN \
  cd /; \
  su - kolla /bin/bash -c 'cd; git clone https://github.com/openstack/kolla.git; \
    cd kolla; \
    git fetch https://git.openstack.org/openstack/kolla refs/changes/69/368469/1 && git checkout FETCH_HEAD; \
    virtualenv .venv; \
    . .venv/bin/activate; \
    pip install pip --upgrade; \
    pip install -r requirements.txt; \
    pip install pyyaml;'

ADD start.sh /start.sh
ADD config /tmp/config

RUN cat /tmp/config >> /home/kolla/kolla/etc/kolla/globals.yml

USER kolla

ENTRYPOINT ["/start.sh"]
CMD ["tools/kolla-ansible", "genconfig"]
