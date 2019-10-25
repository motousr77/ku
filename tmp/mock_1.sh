kubectl run nginx-pod --image=nginx:alpine --generator=run-pod/v1 -o yaml > nginx-pod-def.yaml
kubectl run messaging --image=redis:alpine --generator=run-pod/v1 --labels="tier=msg" -o yaml > msg-pod-def.yaml
kubectl create ns apx-x9984574
kubectl get nodes -o json > /opt/outputs/nodes-z3444kd9.json
kubectl expose pod messaging --port=6379 --name=messaging-service --labels="type=ClusterIp" -o yaml > msg-svc-def.yaml
kubectl run hr-web-app --image=kodekloud/webapp-color --replicas=2 -o yaml > hr-web-app-def.yaml
kubectl run static-busybox --image=busybox --generator=run-pod/v1 --dry-run -o yaml > static-busybox-def.yaml
# edit static-busybox-def && add some fields in container scope after image: command: ["some command"] args: ["argument"]
cp static-busybox-def /etc/kubernetes/manifests/
#
kubectl run temp-bus --image=redis:alpine --namespace=finance --generator=run-pod/v1 -o yaml > temp-bus-def.yaml

kubectl expose deploy hr-web-app --port=8080 --node-port=30080 --type=NodePort --name=hr-web-app-service -o yaml > hr-expose-def.yaml
!!!!!!!!! Endpoints !!! WTF

76% Your score Pass Percentage - 66% 
***
VOLUMES !!!!
JSON PATH !!!!
ENDPOINT on expose to NODES !!!
kubectl get nodes -o !!!!!!!
***
Use JSON PATH query to retrieve the osImages of all the nodes and store it in a file /opt/outputs/nodes_os_x43kj56.txt
The osImages are under the nodeInfo section under status of each node.

***
Expose the hr-web-app as service hr-web-app-service application on port 30082 on the nodes on the cluster
The web application listens on port 8080

    Name: hr-web-app-service
    Type: NodePort
    Endpoints: 2
    Port: 8080
    NodePort: 30082 

***
A new application orange is deployed. There is something wrong with it. Identify and fix the issue.

***
Create a POD in the finance namespace named temp-bus with the image redis:alpine.

Weight: 12

    Name: temp-bus
    Image Name: redis:alpine 
***
Create a static pod named static-busybox that uses the busybox image and 
the command sleep 1000
    Name: static-busybox
    Image: busybox 
***
Create a deployment named hr-web-app using the image kodekloud/webapp-color with 2 replicas
    Name: hr-web-app
    Image: kodekloud/webapp-color
    Replicas: 2
***
Create a service messaging-service to expose the messaging application within the cluster on port 6379.

Use imperative commands
    
	Service: messaging-service
    Port: 6379
    Type: ClusterIp
    
	Use the right labels 
***
