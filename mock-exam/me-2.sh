# 1. Take a backup of the etcd cluster and save it to /tmp/etcd-backup.db # --endpoints=https://[172.17.0.6]:2379 
ETCDCTL_API=3 etcdctl --endpoints=https://[$(kubectl -n kube-system get pod etcd-master -o=jsonpath='{.status.hostIP}')]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /tmp/etcd-backup.db

# 2. Create a Pod called redis-storage with with a Volume ...
cat > redis-storage.yaml << EOF
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
kubectl apply -f redis-storage.yaml

# 3. Create a new pod called super-user-pod with image busybox:1.28
cat > super-user-pod.yaml << EOF
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
    securityContext:
      capabilities:
        add:
        - SYS_TIME
  dnsPolicy: ClusterFirst
  restartPolicy: Always
EOF
kubectl apply -f super-user-pod.yaml

# 4. A pod definition file is created at /root/use-pv.yaml ...
cat > pv-1.yaml << EOF
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
kubectl apply -f pv-1.yaml 
cat > pv-1-claim.yaml << EOF
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
kubectl apply -f pv-1-claim.yaml 
cat > use-pv.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: use-pv
  name: use-pv
spec:
  volumes:
    - name: pv-1 # ??
      persistentVolumeClaim:
        claimName: pv-1-claim
  containers:
  - image: nginx
    name: use-pv
    volumeMounts:
      - mountPath: /data
        name: pv-1 # ??
  dnsPolicy: ClusterFirst
  restartPolicy: Always
EOF
kubectl apply -f use-pv.yaml

# 5. Create a new deployment called nginx-deploy, with image nginx:1.16 and 1 replica. Record the version. Next upgrade the deployment to version 1.17 using rolling update.
kubectl run nginx-deploy --image=nginx:1.16 --replicas=1
kubectl set image deployment/nginx-deploy nginx-deploy=nginx:1.17 --record
# kubectl rollout status deployment/nginx-deploy # .apps/ !!!

# 6. 
Create a new user called john. Grant him access to the cluster. 
John should have permission to create, list, get, update and delete pods in the development namespace. 
The private key exists in the location: /root/john.key and csr at /root/john.csr
    CSR: john-developer Status:Approved
    Role Name: developer, namespace: development, Resource: Pods
    Access: User 'john' has appropriate permissions 

# 7. 
Create an nginx pod called nginx-resolver using image nginx, expose it internally with a service called nginx-resolver-service. 
Test that you are able to look up the service and pod names from within the cluster. 
  Use the image: busybox:1.28 for dns lookup. 
  Record results in /root/nginx.svc and /root/nginx.pod
    Pod: nginx-resolver created
    Service DNS Resolution recorded correctly
    Pod DNS resolution recorded correctly
#
kubectl run --generator=run-pod/v1 --name=nginx-resolver --image= nginx
kubectl expose nginx-resolver --name=nginx-resolver-service

# sudo apt install dnsutils # dig <hostname> # host <hostname> #
host example.com
host -t TYPE example.com
host -t a example.com
host -t mx cyberciti.biz

# 8. Create a static pod on node01 called nginx-critical with image nginx...
kubectl run --generator=run-pod/v1 nginx-static-pod \
--image=nginx --restart=OnFailure \
--dry-run -o yaml > /etc/kubernetes/manifests/nginx-static-pod.yaml && \
echo '  nodeName: node01' >> /etc/kubernetes/manifests/nginx-static-pod.yaml

kubectl run --generator=run-pod/v1 nginx-static \
--image=nginx --restart=OnFailure \
--dry-run -o yaml > /etc/kubernetes/manifests/nginx-static.yaml && \
echo '  nodeName: node01' >> /etc/kubernetes/manifests/nginx-static.yaml
kubectl get pods -o wide


kubectl get nodes -o jsonpath='{.items[1].metadata.name}'

kubectl run --generator=run-pod/v1 nginx-critical-node01 --image=nginx --restart=OnFailure \
--dry-run -o json | jq --arg foo $(kubectl get nodes -o jsonpath='{.items[1].metadata.name}') '. * {"spec": { nodeName: $foo } }' > /etc/kubernetes/manifests/nginx-critical-node01.json

ПЕРВОЕ (статик)
kubectl run --generator=run-pod/v1 nginx-01 --image=nginx --restart=OnFailure \
--dry-run -o json | jq --arg foo $(kubectl get nodes -o jsonpath='{.items[1].metadata.name}') \
'. * {"spec": { nodeName: $foo } }' > /etc/kubernetes/manifests/nginx-01.json

ВТОРОЕ (НЕ статик)
kubectl run --generator=run-pod/v1 nginx-eph --image=nginx --restart=OnFailure \
--dry-run -o json | jq --arg foo $(kubectl get nodes -o jsonpath='{.items[1].metadata.name}') \
'. * {"spec": { nodeName: $foo } }' > nginx-eph.json && \
kubectl apply -f nginx-eph.json

kubectl run --generator=run-pod/v1 nginx-eph --image=nginx:alpine --restart=OnFailure \
--dry-run -o json | jq --arg foo $(kubectl get nodes -o jsonpath='{.items[1].metadata.name}') \
'. * {"spec": { nodeName: $foo } }' > nginx-eph.json && \
kubectl apply -f nginx-eph.json

kubectl run --generator=run-pod/v1 nginx-eph --image=nginx:alpine --restart=OnFailure \
--dry-run -o json | jq --arg foo $(kubectl get nodes -o jsonpath='{.items[2].metadata.name}') \
'. * {"spec": { nodeName: $foo } }' > nginx-eph.json
#
kubectl apply -f nginx-eph.json
# STATIC
kubectl run --generator=run-pod/v1 nginx-01 --image=nginx --restart=OnFailure \
--dry-run -o json | jq --arg foo node2 \
'. * {"spec": { nodeName: $foo } }' > /etc/kubernetes/manifests/nginx-01.json
# EPH
kubectl run --generator=run-pod/v1 nginx-eph --image=nginx:alpine --restart=OnFailure \
--dry-run -o json | jq --arg foo node2 \
'. * {"spec": { nodeName: $foo } }' > nginx-eph.json
#
kubectl apply -f nginx-eph.json


rm /etc/kubernetes/manifests/nginx*

kubectl run --generator=run-pod/v1 nginx-critical-node01 \
--image=nginx --restart=OnFailure --dry-run -o json | jq --arg foo node01 '. * {"spec": { nodeName: $foo } }' > /etc/kubernetes/manifests/nginx-critical-node01.json


kubectl run --generator=run-pod/v1 nginx-test \
--image=nginx --restart=OnFailure --dry-run -o json | jq --arg foo node01 '. * {"spec": { nodeName: $foo } }' > /etc/kubernetes/manifests/nginx-test.json


kubectl run --generator=run-pod/v1 nginx-test \
--image=nginx --restart=OnFailure --dry-run -o json | jq --arg foo node01 '. * {"spec": { nodeName: $foo } }' > nginx-test.json && \
kubectl apply -f nginx-test.json

#
kubectl run --generator=run-pod/v1 nginx-critical-node01 \
--image=nginx --restart=OnFailure \ --dry-run -o json | jq \
--arg foo node01 '. * {"spec": { nodeName: $foo } }' > nginx-critical-node01.json && \
kubectl apply -f nginx-critical-node01.json
#
kubectl run --generator=run-pod/v1 test \
--image=nginx --dry-run -o json | jq \
--arg foo node01 '. * {"spec": { nodeName: $foo } }'> test.json && \
kubectl apply -f test.json

kubectl run --generator=run-pod/v1 nginx-pod \
--image=nginx --dry-run -o yaml > nginx-pod.yaml && \
echo '  nodeName: node01' >> nginx-pod.yaml && \
kubectl apply -f nginx-pod.yaml

# kubectl run --generator=run-pod/v1 nginx-pod --image=nginx --dry-run -o json > test.json
kubectl run --generator=run-pod/v1 test \
--image=nginx --dry-run -o json | jq \
--arg foo node01 '. * {"spec": { nodeName: $foo } }'> test.json && \
kubectl apply -f test.json

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
