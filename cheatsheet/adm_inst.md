### Install control plane on Debian system
~~~
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
~~~
kubeadm version && kubectl version --short && docker version
###### Test networking
~~~
ping -c 2 192.168.5.11 && ping -c 2 192.168.5.21 && ping -c 2 192.168.5.22
~~~

### Docker - CE
~~~sh
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
~~~
~~~sh
sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
~~~
~~~sh
sudo apt-get install docker-ce=18.06.3~ce~3-0~ubuntu containerd.io
~~~

### Useful commands
apt-cache policy <pkg name>
apt install <pkg nam>=<version>

[Install Control Plane](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)
[Install Docker some version](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
[Init Cluster](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
[GIThub repo](https://github.com/motousr77/ku)
<!--  -->
18.06.3~ce~3-0~ubuntu 500
18.06.2~ce~3-0~ubuntu 500
18.06.1~ce~3-0~ubuntu 500
18.06.0~ce~3-0~ubuntu 500
18.03.1~ce~3-0~ubuntu 500
