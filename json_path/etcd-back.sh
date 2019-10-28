kubectl get deployments
kubectl get pods etcd-master -n kube-system -o yaml > about-etcd-master.yml

# Backup ETCD to /tmp/snapshot-pre-boot.db
# Name: ingress-space 
# etcdctl snapshot save snapshot.db

ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
     --cacert=/etc/kubernetes/pki/etcd/ca.crt \
     --cert=/etc/kubernetes/pki/etcd/server.crt \
     --key=/etc/kubernetes/pki/etcd/server.key \
     snapshot save /tmp/snapshot-pre-boot.db

ETCDCTL_API=3 etcdctl snapshot status /tmp/snapshot-pre-boot.db

ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
     --cacert=/etc/kubernetes/pki/etcd/ca.crt \
     --name=master \
     --cert=/etc/kubernetes/pki/etcd/server.crt \
     --key=/etc/kubernetes/pki/etcd/server.key \
     --data-dir /var/lib/etcd-from-backup \
     --initial-cluster=master=https://127.0.0.1:2380 \
     --initial-cluster-token etcd-cluster-1 \
     --initial-advertise-peer-urls=https://127.0.0.1:2380 \
     snapshot restore /tmp/snapshot-pre-boot.db

# /etc/kubernetes/manifests/etcd.yaml

# update lines:
--data-dir=/var/lib/etcd-from-backup
--initial-cluster-token=etcd-cluster-1

# -------------------------------------
  volumes:
  - hostPath:
      path: /var/lib/etcd-from-backup
      type: DirectoryOrCreate
    name: etcd-data
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/practice-questions-answers/cluster-maintenance/backup-etcd/etcd-backup-and-restore.md

