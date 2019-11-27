# 1. GO MOCK
kubectl -n kube-system describe pod etcd-master
# Take a backup of the etcd cluster and save it to /tmp/etcd-backup.db
ETCDCTL_API=3 etcdctl --endpoints=https://[172.17.0.10]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /tmp/etcd-backup.db

# 2. Create a Pod called redis-storage with with a Volume of type emptyDir that lasts for the life of the Pod.
cat > redis-storage-def.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: redis-storage
spec:
  containers:
  - image: redis:alpine
    name: redis-storage
    volumeMounts:
    - mountPath: /data/redis
      name: data
  restartPolicy: Always
  volumes:
    - emptyDir: {}
      name: data
EOF

# 3. Create a new pod called super-user-pod with image busybox:1.28.
cat > super-user-pod-def.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: super-user-pod
  name: super-user-pod
spec:
  containers:
  - command:
    - sleep
    - "4800"
    image: busybox:1.28
    name: super-user-pod
    resources: {}
    securityContext:
      capabilities:
        add:
        - SYS_TIME
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
EOF

# 4. A pod definition file is created at /root/use-pv.yaml. 
cat > pv-1-def.yaml << EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-1
spec:
  storageClassName: ""
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 300Mi
  hostPath:
    path: /tmp/data
EOF
cat > pv-1-claim-def.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pv-1-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 200Mi
EOF
cat > use-pv.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: use-pv
  name: use-pv
spec:
  volumes:
    - name: pv-storage
      persistentVolumeClaim:
        claimName: pv-1-claim
  containers:
  - image: nginx
    name: use-pv
    volumeMounts:
      - mountPath: /data
        name: pv-storage
  dnsPolicy: ClusterFirst
  restartPolicy: Always
EOF
# 5. 



# --- --- --- --- --- --- --- --- --- --- --- --- #
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
spec:
  containers:
  - name: friendly-container
    image: "alpine:3.4"
    command: ["/bin/echo", "hello", "world"]
    securityContext:
      capabilities:
        add:
        - SYS_NICE
        drop:
        - KILL
# --- --- --- --- --- --- --- --- --- --- --- --- #
etcd
--advertise-client-urls=https://172.17.0.73:2379
--cert-file=/etc/kubernetes/pki/etcd/server.crt
--client-cert-auth=true
--data-dir=/var/lib/etcd
--initial-advertise-peer-urls=https://172.17.0.73:2380
--initial-cluster=master=https://172.17.0.73:2380
--key-file=/etc/kubernetes/pki/etcd/server.key
--listen-client-urls=https://127.0.0.1:2379,https://172.17.0.73:2379
--listen-peer-urls=https://172.17.0.73:2380
--name=master
--peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
--peer-client-cert-auth=true
--peer-key-file=/etc/kubernetes/pki/etcd/peer.key
--peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
--snapshot-count=10000
--trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt




#  FROM LABS -> 
# 1 Take a backup of the etcd cluster and save it to /tmp/etcd-backup.db
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
     --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
     snapshot save /tmp/snapshot-pre-boot.db
# 2 
ETCDCTL_API=3 etcdctl --write-out=table snapshot status /tmp/snapshot-pre-boot.db
# 3
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
--name=master --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
--data-dir=/var/lib/etcd-from-backup --initial-cluster=master=https://127.0.0.1:2380 \
--initial-cluster-token=etcd-cluster-1 --initial-advertise-peer-urls=https://127.0.0.1:2380 \
snapshot restore /tmp/snapshot-pre-boot.db
# 4 
Update ETCD POD to use the new data directory and cluster token by modifying the pod definition file at /etc/kubernetes/manifests/etcd.yaml. When this file is updated, the ETCD pod is automatically re-created as thisis a static pod placed under the /etc/kubernetes/manifests directory.

Update --data-dir to use new target location
--data-dir=/var/lib/etcd-from-backup

Update new initial-cluster-token to specify new cluster
--initial-cluster-token=etcd-cluster-1

# vim /etc/kubernetes/manifests/etcd.yaml

# may be ROOT will need!
ETCDCTL_API=3 etcdctl --endpoints=https://[192.168.6.11]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /tmp/snapshot-pre-boot.db

ETCDCTL_API=3 etcdctl --write-out=table snapshot status /tmp/snapshot-pre-boot.db

--advertise-client-urls=https://192.168.6.11:2379
--cert-file=/etc/kubernetes/pki/etcd/server.crt # --cert
--data-dir=/var/lib/etcd
--initial-advertise-peer-urls=https://192.168.6.11:2380
--initial-cluster=master-1=https://192.168.6.11:2380
--key-file=/etc/kubernetes/pki/etcd/server.key # --key
--listen-client-urls=https://127.0.0.1:2379,https://192.168.6.11:2379
--trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt # --cacert

GLOBAL OPTIONS:
      --cacert=""                               verify certificates of TLS-enabled secure servers using this CA bundle
      --cert=""                                 identify secure client using this TLS certificate file
      --command-timeout=5s                      timeout for short running command (excluding dial timeout)
      --debug[=false]                           enable client-side debug logging
      --dial-timeout=2s                         dial timeout for client connections
      --endpoints=[127.0.0.1:2379]              gRPC endpoints
      --hex[=false]                             print byte strings as hex encoded strings
      --insecure-skip-tls-verify[=false]        skip server certificate verification
      --insecure-transport[=true]               disable transport security for client connections
      --key=""                                  identify secure client using this TLS key file
      --user=""                                 username[:password] for authentication (prompt if password is not supplied)
  -w, --write-out="simple"                      set the output format (fields, json, protobuf, simple, table)

kubectl cluster-info
Kubernetes master is running at https://192.168.6.11:6443
KubeDNS is running at https://192.168.6.11:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/practice-questions-answers/cluster-maintenance/backup-etcd/etcd-backup-and-restore.md

https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/practice-questions-answers/cluster-maintenance/backup-etcd/etcd-backup-and-restore.md
