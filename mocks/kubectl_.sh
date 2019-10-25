kubectl logs my-pod 
kubectl logs -l name=myLabel 
kubectl logs my-pod --previous 
kubectl logs my-pod -c my-container 
kubectl logs -l name=myLabel -c my-container 
kubectl logs my-pod -c my-container --previous 
kubectl logs -f my-pod 
kubectl logs -f my-pod -c my-container 
kubectl logs -f -l name=myLabel --all-containers 
kubectl run -i --tty busybox --image=busybox -- sh 
kubectl run nginx --image=nginx --restart=Never -n 
kubectl run nginx --image=nginx --restart=Never --dry-run -o yaml > pod.yaml 
kubectl attach my-pod -i 
kubectl port-forward my-pod 5000:6000 
kubectl exec my-pod -- ls /               
kubectl exec my-pod -c my-container -- ls / 
kubectl top pod POD_NAME --containers 
