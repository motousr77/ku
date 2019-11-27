You just have to enter the command:

source ~/.bashrc

or you can use the shorter version of the command:

. ~/.bashrc

---

Use for get info about taints on nodes:

kubectl get nodes -o json | jq '.items[].spec'

which will give the complete spec with node name, or:

kubectl get nodes -o json | jq '.items[].spec.taints'

will produce the list of the taints per each node.

---

kubectl taint nodes <node_name> key=value:NoSchedule

kubectl taint nodes <node_name> key:NoSchedule-

---
kubectl get svc <svc-name> -o json | jq '.spec.clusterIP'