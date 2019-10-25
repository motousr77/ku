# kubectl run nginx-pod --image=nginx:alpine --restart=Never --dry-run -o yaml > nginx-pod.yaml
kubectl run nginx-pod --image=nginx:alpine --restart=Never -o yaml > nginx-pod-def.yaml
kubectl run messaging --image=redis:alpine --restart=Never --labels="tier=msg" -o yaml > redis-pod-def.yaml
kubectl 


Create a namespace named apx-x9984574
Namespace: apx-x9984574
Deploy a messaging pod using the redis:alpine image with the labels set to tier=msg.
Pod Name: messaging
Image: redis:alpine
Labels: tier=msg