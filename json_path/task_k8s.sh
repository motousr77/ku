# https://kubernetes.io/docs/tasks/
1. Deploy and access the Dashboard web user interface to help you manage and monitor containerized applications in a Kubernetes cluster.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta6/aio/deploy/recommended.yaml
kubectl proxy
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/