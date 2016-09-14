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
    git fetch https://git.openstack.org/openstack/kolla refs/changes/27/369127/2 && git checkout FETCH_HEAD; \
    virtualenv .venv; \
    . .venv/bin/activate; \
    pip install pip --upgrade; \
    pip install -r requirements.txt; \
    pip install pyyaml; \
    cd ..; git clone https://github.com/openstack/kolla-kubernetes.git; \
    cd kolla-kubernetes; \
    pip install -r requirements.txt; \
    pip install .; echo force rebuild 1'

ADD start.sh /start.sh
ADD config /tmp/config
ADD gen_keystone_admin.sh /home/kolla/gen_keystone_admin.sh
ADD openstackcli.yaml /home/kolla/openstackcli.yaml
ADD stash_config.sh /home/kolla/stash_config.sh

RUN cat /tmp/config >> /home/kolla/kolla/etc/kolla/globals.yml

#FIXME... This should copy the files over if they are unchanged... md5sum
RUN ln -s /home/kolla/kolla-kubernetes/etc/kolla-kubernetes /etc/kolla-kubernetes

RUN ln -s /home/kolla/kolla /usr/share/kolla

RUN yum install -y jq wget sudo

RUN sed -i 's/sudo//' /home/kolla/kolla-kubernetes/tools/setup-kubectl.sh; /home/kolla/kolla-kubernetes/tools/setup-kubectl.sh

RUN mkdir /etc/kolla; chown kolla /etc/kolla

USER kolla

ENTRYPOINT ["/start.sh"]
CMD ["tools/kolla-ansible", "genconfig"]
