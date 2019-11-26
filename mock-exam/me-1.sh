# 1 Deploy a pod named nginx-pod using the nginx:alpine image.
# Once done, click on the Next Question button in the top right corner of this panel. You may navigate back and forth freely between all questions. Once done with all questions, click on End Exam. Your work will be validated at the end and score shown. Good Luck!
#     Name: nginx-pod
#     Image: nginx:alpine
kubectl run --generator=run-pod/v1 nginx-pod --image=nginx:alpine

# 2 Deploy a messaging pod using the redis:alpine image with the labels set to tier=msg.
#     Pod Name: messaging
#     Image: redis:alpine
#     Labels: tier=msg 
kubectl run --generator=run-pod/v1 messaging --image=redis:alpine --labels="tier=msg"

# 3 Create a namespace named apx-x9984574
#     Namespace: apx-x9984574 
kubectl create ns apx-x9984574

# 4 Get the list of nodes in JSON format and store it in a file at /opt/outputs/nodes-z3444kd9.json
kubectl get nodes -o json > /opt/outputs/nodes-z3444kd9.json
# 5 Create a service messaging-service to expose the messaging application within the cluster on port 6379.
# Use imperative commands
#    Service: messaging-service
#    Port: 6379
#    Type: ClusterIp
#    Use the right labels 
# _ supported values: "ClusterIP", "ExternalName", "LoadBalancer", "NodePort"
kubectl expose pod messaging --name=messaging-service --type=ClusterIP  --port=6379 --selector="tier=msg"

# 6 Create a deployment named hr-web-app using the image kodekloud/webapp-color with 2 replicas
  # Name: hr-web-app
  # Image: kodekloud/webapp-color
  # Replicas: 2 
# kubectl create deployment --name=hr-web-app --image=kodekloud/webapp-color --replicas=2
kubectl run hr-web-app --image=kodekloud/webapp-color --replicas=2

# 7 Create a static pod named static-busybox that uses the busybox image and the 
    # command sleep 1000
    # Name: static-busybox
    # Image: busybox 
kubectl run --generator=run-pod/v1 static-busybox --image=busybox --dry-run -o yaml > /etc/kubernetes/manifests/static-busybox.yaml

# 8 Create a POD in the finance namespace named temp-bus with the image redis:alpine.
    # Name: temp-bus
    # Image Name: redis:alpine 
# kubectl create ns finance # namespaces finance allready exist !!!
kubectl run --generator=run-pod/v1 temp-bus --image=redis:alpine --namespace=finance

# 9 A new application orange is deployed. There is something wrong with it. Identify and fix the issue.
kubectl get pod orange -o yaml > orange-pod-def.yaml # edit sleeeep

# 10 Expose the hr-web-app as service hr-web-app-service application on port 30082 on the nodes on the cluster
# The web application listens on port 8080
    # Name: hr-web-app-service
    # Type: NodePort
    # Endpoints: 2
    # Port: 8080
    # NodePort: 30082 # add to end of spec ports -> nodPort: 30082
kubectl expose deployment hr-web-app --name=hr-web-app-service --type=NodePort --port=8080 --dry-run -o yaml > svc-hr-def.yaml

# 11 Use JSON PATH query to retrieve the osImages of all the nodes and store it in a file /opt/outputs/nodes_os_x43kj56.txt
# The osImages are under the nodeInfo section under status of each node.
# osIMAGE !!!!!!!!! 
kubectl get nodes -o=jsonpath='{.items[*].status.nodeInfo.osImage}'  > /opt/outputs/nodes_os_x43kj56.txt

# 12 Create a Persistent Volume with the given specification.
    # Volume Name: pv-analytics
    # Storage: 100Mi
    # Access modes: ReadWriteMany
    # Host Path: /pv/data-analytics 
cat > pv-def.yaml << EOF
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
# ALL CORRECT !!!

