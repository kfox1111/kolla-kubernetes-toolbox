#Building
docker build -t kolla-kubernetes-toolbox:latest .

#SETUP - As root:
D=/tmp/kolla/regionone
mkdir -p $D
chmod 777 $D
chmod +t $D
mkdir -p $D

#As any user
D=/tmp/kolla/regionone
docker run -it --rm -v $D:/etc/kolla -v ~/.kube:/home/kolla/.kube kolla-kubernetes-toolbox:latest /bin/bash

