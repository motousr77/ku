# 1. Take a backup of the etcd cluster and save it to /tmp/etcd-backup.db 
ETCDCTL_API=3 etcdctl --endpoints=https://[$(kubectl -n kube-system get pod etcd-master -o=jsonpath='{.status.hostIP}')]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /tmp/etcd-backup.db

# 2. Create a Pod called redis-storage with with a Volume ...
cat << EOF | kubectl apply -f -
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

# 3. Create a new pod called super-user-pod with image busybox:1.28
cat << EOF | kubectl apply -f -
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

# 4. A pod definition file is created at /root/use-pv.yaml ...
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pv-1-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Mi
EOF
#
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: use-pv
  name: use-pv
spec:
  volumes:
    - name: pv-1
      persistentVolumeClaim:
        claimName: pv-1-claim
  containers:
  - image: nginx
    name: use-pv
    volumeMounts:
      - mountPath: /data
        name: pv-1
  dnsPolicy: ClusterFirst
  restartPolicy: Always
EOF

# 5. Create a new deployment called nginx-deploy...
kubectl run nginx-deploy --image=nginx:1.16 --replicas=1 --record
kubectl set image deployment/nginx-deploy nginx-deploy=nginx:1.17 --record
# kubectl rollout status deployment/nginx-deploy # .apps/ !!!
# kubectl rollout history deployment/nginx-deploy
# kubectl rollout undo deployment nginx-deploy

# 6. Create a new user called john. Grant him access to the cluster...
# kubectl api-versions | grep cert
# use ENV for new user ! (in future commits)
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: john-developer
spec:
  request: $(cat john.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
#
kubectl certificate approve john-developer
kubectl create role developer --resource=pods --verb=create,get,list,update,delete \
--namespace=development
kubectl create rolebinding developer-role-binding --role=developer \
--user=john --namespace=development
# kubectl -n development describe rolebinding developer-role-binding

# 7. Create an nginx pod called nginx-resolver using image nginx, expose it ...
kubectl run --generator=run-pod/v1 nginx-resolver --image=nginx
kubectl expose pod nginx-resolver --name=nginx-resolver-service \
--port=80 --target-port=80 --type=ClusterIP

# 8. Create a static pod on node01 called nginx-critical with image nginx...
# Goto NODE01 by ssh or scp to node01 !!!
kubectl run --generator=run-pod/v1 nginx-critical --image=nginx --restart=OnFailure \
--dry-run -o json | jq --arg foo $(kubectl get nodes -o jsonpath='{.items[1].metadata.name}') \
'. * {"spec": { nodeName: $foo } }' > nginx-critical.json && \
ssh node01 mkdir /etc/kubernetes/manifests && \
scp master:~/nginx-critical.json node01:/etc/kubernetes/manifests/
# !!! correct :)

# Add --pod-manifest-path to kubelet service on worker or staticPodPath in the kubelet config.yaml

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

https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/practice-questions-answers/cluster-maintenance/backup-etcd/etcd-backup-and-restore.md

