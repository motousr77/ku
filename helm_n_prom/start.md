### Installation
From [https://helm.sh/docs/intro/install/](https://helm.sh/docs/intro/install/)
~~~sh
wget https://get.helm.sh/helm-v3.0.1-linux-amd64.tar.gz
tar -zxvf helm-v3.0.1-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
# ##
~~~

### Initialize a helm chart repository
From [https://helm.sh/docs/intro/quickstart/](https://helm.sh/docs/intro/quickstart/)
~~~sh
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
# chesk list
helm search repo stable
# update repo
helm repo update
~~~
#### -
~~~sh
# 
~~~
helm values YAML

~~~



~~~sh
vagrant@master-1:~$ helm install stable/mysql --generate-name
NAME: mysql-1575887362
LAST DEPLOYED: Mon Dec  9 10:29:24 2019
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
MySQL can be accessed via port 3306 on the following DNS name from within your cluster:
mysql-1575887362.default.svc.cluster.local

To get your root password run:

    MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default mysql-1575887362 -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

To connect to your database:

1. Run an Ubuntu pod that you can use as a client:

    kubectl run -i --tty ubuntu --image=ubuntu:16.04 --restart=Never -- bash -il

2. Install the mysql client:

    $ apt-get update && apt-get install mysql-client -y

3. Connect using the mysql cli, then provide your password:
    $ mysql -h mysql-1575887362 -p

To connect to your database directly from outside the K8s cluster:
    MYSQL_HOST=127.0.0.1
    MYSQL_PORT=3306

    # Execute the following command to route the connection:
    kubectl port-forward svc/mysql-1575887362 3306

    mysql -h ${MYSQL_HOST} -P${MYSQL_PORT} -u root -p${MYSQL_ROOT_PASSWORD}
vagrant@master-1:~$
~~~

kubectl port-forward -n demo demo-grafana  9090

kubectl port-forward $(kubectl get pods --selector=app=grafana --output=jsonpath="{.items..metadata.name}") 3000

