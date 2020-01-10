kubectl get clusterroles --no-headers | wc -l
kubectl get clusterroles --no-headers -o json | jq '.items | length'

kubectl get clusterrolebindings --no-headers | wc -l 
kubectl get clusterrolebindings --no-headers -o json | jq '.items | length'

kubectl describe clusterrolebinding cluster-admin # system:masters
kubectl describe clusterrole cluster-admin # '*' - define ANY actions in the clister

openssl genrsa -out akshay.key 2048
openssl req -new -key akshay.key -subj "/CN=akshay" -out akshay.csr

kubectl apply -f akshay-csr.yaml
kubectl get csr
kubectl certificate approve akshay
kubectl get csr
