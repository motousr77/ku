kubectl create ns ghost
kubectl create quota blog --hard=pods=1 -n ghost
kubectl run ghost --image=ghost -n ghost
kubectl expose deployments ghost --port 2368 --type LoadBalancer -n ghost
#
kubectl scale deployment ghost --replicas 2 -n ghost
#
kubectl create service clusterip foobar --tcp=80:80
#
kubectl run --generator=run-pod/v1 foobar --image=nginx
#
kubectl run --generator=run-pod/v1 foobar --image=nginx — serviceaccount=foobar --requests=cpu=100m,memory=256Mi
#
kubectl get deployments ghost --export -n ghost -o yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
 annotations:
 deployment.kubernetes.io/revision: “1”
 creationTimestamp: null
 generation: 1
 labels:
 run: ghost
 name: ghost
 selfLink: /apis/extensions/v1beta1/namespaces/ghost/deployments/ghost
spec:
…
#
$ kubectl get deployments ghost --export -n ghost -o yaml > ghost.yaml
$ vi ghost.yaml
$ kubectl replace -f ghost.yaml
#
kubectl create service clusterip foobar --tcp=80:80 -o json --dry-run
{
 “kind”: “Service”,
 “apiVersion”: “v1”,
 “metadata”: {
 “name”: “foobar”,
 “creationTimestamp”: null,
 “labels”: {
 “app”: “foobar”
 }
 },
 “spec”: {
 “ports”: [
 {
 “name”: “80–80”,
 “protocol”: “TCP”,
 “port”: 80,
 “targetPort”: 80
 }
 ],
 “selector”: {
 “app”: “foobar”
 },
 “type”: “ClusterIP”
 },
 “status”: {
 “loadBalancer”: {}
 }
}
#
kubectl scale deployment ghost -n ghost — replicas 2
kubectl get pods -n ghost
NAME READY STATUS RESTARTS AGE
ghost-8449997474–65699 1/1 Running 0 3m
ghost-8449997474-t856r 1/1 Running 1 20h
vi ghost.yaml #change the image
kubectl replace -f ghost.yaml -n ghost
kubectl get pods -n ghost
NAME READY STATUS RESTARTS AGE
ghost-5459464f7b-xjs74 0/1 ContainerCreating 0 2s
ghost-8449997474–65699 0/1 Terminating 0 5m
ghost-8449997474-t856r 0/1 Terminating 1 20h
# Declarative
kubectl apply -f <object>.<yaml,json>


