This document outlines how to install Calico on a cluster initialized with kubeadm. Calico is compatible with kubeadm-created clusters, as long as the requirements are met.

For Calico to be compatible with your kubeadm-created cluster:
    It must be running at least Kubernetes v1.7
    There should be no other CNI network configurations installed in /etc/cni/net.d (or equivalent directory)
    The kubeadm flag --pod-network-cidr must be set when creating the cluster with kubeadm init and the CIDR(s) specified with the flag must match Calico’s IP pools. 
    The default IP pool configured in Calico’s manifests is 192.168.0.0/16
    The CIDR specified with the kubeadm flag --service-cidr must not overlap with Calico’s IP pools
        The default CIDR for --service-cidr is 10.96.0.0/12
        The default IP pool configured in Calico’s manifests is 192.168.0.0/16

You can create a cluster compatible with these manifests by following the official kubeadm guide.
Installing Calico with a Kubernetes-hosted etcd
As a non-production quick start, to install Calico with a single-node dedicated etcd cluster, running as a Kubernetes pod:
    Ensure your cluster meets the requirements (or recreate it if not).
    Apply the single-node etcd manifest:
    
    kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml

# init under ROOT or use SUDO
kubeadm init --apiserver-advertise-address=192.168.6.11 --pod-network-cidr=172.16.0.0/16



kubeadm init --apiserver-advertise-address=$(hostname -i) --pod-network-cidr=172.16.0.0/16

#
mkdir -p $HOME/.kube && \
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && \
sudo chown $(id -u):$(id -g) $HOME/.kube/config

mkdir -p $HOME/.kube && cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/
#
kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml
#

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.6.11:6443 --token y3w70o.w08wolcjcobd785b \
    --discovery-token-ca-cert-hash sha256:c323ff5c376a0e7d65e056463cf95b82c020578c21ef8ab1df20721edaca2341

kubeadm join 192.168.0.21:6443 --token nbztrc.bekzcg4svrru2j5p --discovery-token-ca-cert-hash sha256:440a7de0b6ecd542d69e6c47b4d9f0ea760ccfcc570c102d58c353e4b7ef30af

kubeadm join 192.168.0.21:6443 --token nbztrc.bekzcg4svrru2j5p --discovery-token-ca-cert-hash sha256:440a7de0b6ecd542d69e6c47b4d9f0ea760ccfcc570c102d58c353e4b7ef30af
#
