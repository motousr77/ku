### From GoLang to Kind. From Kind
Before install kind u need install Docker
##### Install Go Language
From: https://golang.org/dl/
https://golang.org/doc/install/source#install
~~~sh
cd $HOME

wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz
tar -xzvf go1.13.5.linux-amd64.tar.gz

export GOPATH=$HOME/GoWork
export GOOROOT=
~~~




##### Install Helm 2
From [Desired Version HELM 2] (https://github.com/helm/helm/releases/tag/v2.16.1)
wget https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz


##### Install Helm 3
From [Desired Version of Helm on GitHub](https://github.com/helm/helm/releases)
wget https://get.helm.sh/helm-v3.0.1-linux-amd64.tar.gz
tar -xzvf helm-v3.0.1-linux-amd64.tar.gz

##### Some of KataCode:
https://www.katacoda.com/javajon/courses/kubernetes-pipelines/helm
Get script to install helm
~~~sh
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
# init helm for get Tiller !!!
helm init
# check tiller-deploy-***
kubectl -n kube-system get pods | grep tiller
# update helm repository
helm repo update
# ls $(helm home) # echo $(helm home)
ls $(helm home)
# search for redis chart
helm search redis
# for more information use inspect (command)
helm inspect stable/redis
# deploy redis
helm install stable/redis --name my-redis # for 3+ version --name is deprecated - use onlu my-redis, for example
# check my deploy:
helm list # or use
helm ls
# Observe Redis
# kubectl get deploy,po,svc
watch kubectl get deployments,pods,services
# create persistent volumes
kubectl apply -f pv.yaml
# create some directories
mkdir /mnt/data1 /mnt/data2 /mnt/data3 --mode=777
# check result
kubectl get deploy,po,svc
# Remove Redis Aplpication
helm delete my-redis --purge
# Explore Repositories
helm repo list
# countstable charts
echo "The number of common charts is, stable: $(helm search stable | wc -l)."
# the list is long. 
helm search stable | sed -E "s/(.{27}).*$/\1/"
#
~~~
###### Add Repositories
~~~sh
helm search fabric8
# add repository
helm repo add fabric8 https://fabric8.io/helm
# 
helm repo list
#
helm search fabric8
#
helm inspect fabric8/ipaas-platform
# INCUBATOR CHarts
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
#
helm search | grep -c 'incubator/'
~~~
###### Create Chart
~~~sh
helm create app-chart
# 
tree app-chart
#
cat app-chart/templates/deployment.yaml | grep 'kind:' -n -B1 -A5
#
cat app-chart/templates/deployment.yaml | grep 'image:' -n -B3 -A3
#
cat app-chart/values.yaml | grep 'repository' -n -B3 -A3
# Observe how the container image name is injected into the template:
helm install --dry-run --debug ./app-chart | grep 'image: "' -n -B3 -A3
# ... change the Nginx container version number from latest to more definitive Nginx version
heml install --dry-run --debug ./app-chart --set image.tag=1.17-alpine | grep 'image: "' -n -B3 -A3
# With the version injecting correctly, install it
helm install --name my-app ./app-chart --set image.tag=1.17-alpine
#
helm list
#
kubectl get deploy,svc,po
~~~
###### Update Chart
~~~sh
helm upgrade my-app ./app-chart --install --reuse-values --set service.type=NodePort
# spme patch for modify nodePort value
kubectl patch service my-app-app-chart --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 31111}]'
# 
~~~
Source repos for the incubators: https://github.com/helm/charts/tree/master/incubator
<!-- pv.yaml -->
~~~yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-volume1
  labels:
    type: local
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data1"
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-volume2
  labels:
    type: local
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data2"
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-volume3
  labels:
    type: local
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data3"
~~~
###### Some output after deploynebt application
~~~sh
master $ helm install stable/redis --name my-redis
NAME:   my-redis
LAST DEPLOYED: Wed Dec 11 14:27:45 2019
NAMESPACE: defaultSTATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME             AGE
my-redis         4s
my-redis-health  4s==> v1/Pod(related)NAME               AGE
my-redis-master-0  0s
my-redis-slave-0   0s
==> v1/SecretNAME      AGE
my-redis  4s
==> v1/ServiceNAME               AGE
my-redis-headless  3s
my-redis-master    3s
my-redis-slave     3s

==> v1/StatefulSet
NAME             AGE
my-redis-master  2s
my-redis-slave   2s

NOTES:
** Please be patient while the chart is being deployed **
Redis can be accessed via port 6379 on the following DNS names from within your cluster:

my-redis-master.default.svc.cluster.local for read/write operations
my-redis-slave.default.svc.cluster.local for read-only operations

To get your password run:
    export REDIS_PASSWORD=$(kubectl get secret --namespace default my-redis -o jsonpath="{.data.redis-password}" | base64 --decode)

To connect to your Redis server:
1. Run a Redis pod that you can use as a client:
   kubectl run --namespace default my-redis-client --rm --tty -i --restart='Never' \
    --env REDIS_PASSWORD=$REDIS_PASSWORD \
   --image docker.io/bitnami/redis:5.0.7-debian-9-r12 -- bash

2. Connect using the Redis CLI:
   redis-cli -h my-redis-master -a $REDIS_PASSWORD
   redis-cli -h my-redis-slave -a $REDIS_PASSWORD

To connect to your database from outside the cluster execute the following commands:
    kubectl port-forward --namespace default svc/my-redis-master 6379:6379 &
    redis-cli -h 127.0.0.1 -p 6379 -a $REDIS_PASSWORD
~~~


###### Different
Some script for install helm
https://raw.githubusercontent.com/helm/helm/master/scripts/get
