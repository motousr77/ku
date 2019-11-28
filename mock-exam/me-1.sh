# 1. Deploy a pod named nginx-pod using the image nginx:alpine
kubectl run --generator=run-pod/v1 nginx-pod --image=nginx:alpine

# 2. Deploy a messaging pod using the redis:alpine image with the labels set to tier=msg
kubectl run --generator=run-pod/v1 messaging --image=redis:alpine --labels="tier=msg"

# 3. Create a namespace named apx-x9984574
kubectl create ns apx-x9984574

# 4. Get the list of nodes in JSON format and store it in a file at /opt/outputs/nodes-z3444kd9.json
kubectl get nodes -o json > /opt/outputs/nodes-z3444kd9.json

# 5. Create a service messaging-service to expose the messaging application within the cluster on port 6379
kubectl expose pod messaging --name=messaging-service --type=ClusterIP  --port=6379 --selector="tier=msg"

# 6. Create a deployment named hr-web-app using the image kodekloud/webapp-color with 2 replicas
kubectl run hr-web-app --image=kodekloud/webapp-color --replicas=2

# 7. Create a static pod named static-busybox that uses the busybox image ...
kubectl run --generator=run-pod/v1 static-busybox --image=busybox --dry-run -o yaml > /etc/kubernetes/manifests/static-busybox.yaml

# 8. Create a POD in the finance namespace named temp-bus with the image redis:alpine
kubectl run --generator=run-pod/v1 temp-bus --image=redis:alpine --namespace=finance

# 9. A new application orange is deployd ... Identify and fix the issue
kubectl get pod orange -o yaml > orange-pod-def.yaml # edit sleeeep -> sleep

# 10. Expose the hr-web-app as service hr-web-app-service application on port 30082 on the nodes on the cluster # add more spec into file.
kubectl expose deployment hr-web-app --name=hr-web-app-service --type=NodePort --port=8080 --dry-run -o yaml > svc-hr-def.yaml

# 11. Use JSON PATH query to retrieve the osImages of all the nodes and store it into file /opt/outputs/nodes_os_x43kj56.txt # osIMAGE !!!!!!!!! 
kubectl get nodes -o=jsonpath='{.items[*].status.nodeInfo.osImage}'  > /opt/outputs/nodes_os_x43kj56.txt

# 12. Create a Persistent Volume...
cat > pv-analytics.yaml << EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-analytics
spec:
  accessModes:
    - ReadWriteMany
  capacity:
    storage: 100Mi
  hostPath:
    path: /pv/data-analytics
EOF
kubectl apply -f pv-def.yaml
