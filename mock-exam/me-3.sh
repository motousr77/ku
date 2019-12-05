# 1. Create a new service account with the name pvviewer...
kubectl create sa pvviewer && kubectl create clusterrole pvviewer-role --resource=persistentvolumes --verb=list
kubectl create clusterrolebinding pvviewer-role-binding --clusterrole=pvviewer-role --serviceaccount=default:pvviewer
#
cat << EOF | kubectl create -f -
$(kubectl run --generator=run-pod/v1 pvviewer --image=redis --dry-run \
-o json |jq --arg foo pvviewer '.*{"spec":{serviceAccountName: $foo}}')
EOF

# 2. List the InternalIP of all nodes of the cluster. Save the result to a file /root/node_ips
kubectl get nodes -o=jsonpath='{.items[*].status.addresses[].address}' > /root/node_ips

# 3. Create a pod called multi-pod with two containers...
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multi-pod
spec:
  containers:
  - name: alpha
    image: nginx
    env:
    - name: name
      value: alpha
  - name: beta
    image: busybox
    env:
    - name: name
      value: beta
    command: ["sleep", "4800"]
EOF

# 4. Create a Pod called non-root-pod , image: redis:alpine, runAsUser: 1000, fsGroup: 2000
cat <<EOF | kubectl apply -f -
$(kubectl run --generator=run-pod/v1 non-root-pod --image=redis:alpine --dry-run \
-o json | jq '.*{"spec": {"securityContext": {"runAsUser": 1000, "fsGroup": 2000}}}')
EOF

# 5. Create NetworkPolicy...
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-to-nptest
spec:
  podSelector:
    matchLabels:
      run: np-test-1
  policyTypes:
  - Ingress
  ingress:
  - from:
    ports:
    - protocol: TCP
      port: 80
EOF

# 6.Taint the worker node node01 to be Unschedulable. 
kubectl taint nodes node01 key=value:NoSchedule
kubectl run --generator=run-pod/v1 dev-redis --image=redis:alpine --overrides='{"spec": {"nodeSelector": {"kubernetes.io/hostname": "node01"}}}'
#
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: prod-redis
spec:
  containers:
  - name: prod-redis
    image: redis:alpine
  tolerations:
  - key: key
    value: production
    operator: Equal
    effect: NoSchedule
EOF
# kubectl get no node01 -o=jsonpath='{.spec.taints}'

# 7. Create a pod called hr-pod in hr namespace belonging to the production environment and frontend tier.
kubectl create ns hr
kubectl run --generator=run-pod/v1 hr-pod --namespace=hr --image=redis:alpine --labels="tier=frontend,environment=production" -o yaml > hr-pod-gen.yaml

# 8. 
sed -i 's/:2379/:6443/g' /root/super.kubeconfig
kubectl cluster-info --kubeconfig=/root/super.kubeconfig

# 9. We have created a new deployment called nginx-deploy. scale the deployment to 3 replicas.
kubectl scale deployment nginx-deploy --replicas=3
sed -i 's/contro1ler/controller/g' /etc/kubernetes/manifests/kube-controller-manager.yaml 

# Done.