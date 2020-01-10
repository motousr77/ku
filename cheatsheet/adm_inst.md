## Install control plane on Debian system
~~~sh
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# ^ ...
kubeadm version && kubectl version --short && docker version
~~~
#### Deploying flannel manually
Flannel can be added to any existing Kubernetes cluster though it's simplest to add flannel before any pods using the pod network have been started.
For Kubernetes v1.7+ 
~~~sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
~~~
### Docker - CE
~~~sh
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
sudo apt-get install docker-ce=18.06.3~ce~3-0~ubuntu containerd.io
~~~
### Init Cluster 
<!-- for flanel -->
~~~sh
kubeadm init --apiserver-advertise-address=$(echo $(hostname -i) \
  | cut -d ' ' -f 1) \
  --pod-network-cidr 10.244.0.0/16

# ^ ...
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
~~~
### Useful commands
~~~sh
apt-cache policy <pkg name>
apt install <pkg nam>=<version>
kubectl label node <node_name> node-role.kubernetes.io/<role>=<role>
kubectl label node worker-1 node-role.kubernetes.io/worker=worker
~~~
\
[Install Control Plane](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)
\
[Install Docker some version](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
\
[Some Of This Twice](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker)
\
[Init Cluster](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
\
[GIThub repo](https://github.com/motousr77/ku)
<!-- 18.06.3~ce~3-0~ubuntu 18.06.2~ce~3-0~ubuntu 18.06.1~ce~3-0~ubuntu 18.06.0~ce~3-0~ubuntu 18.03.1~ce~3-0~ubuntu 500 -->

## Install Docker CE
#### Install packages to allow apt to use a repository over HTTPS
~~~sh
apt-get update && apt-get install apt-transport-https ca-certificates curl software-properties-common

#### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

#### Add Docker apt repository.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

### Install Docker CE.
apt-get update && apt-get install docker-ce=18.06.2~ce~3-0~ubuntu

## Setup daemon.
<!-- may be u need edit into vim -->
sudo cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker
~~~