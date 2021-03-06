kubectl get nodes -o=jsonpath='{.items[*].metadata.name}' > /opt/outputs/node_names.txt
kubectl get nodes -o=jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os.txt

kubectl config view --kubeconfig=/root/my-kube-config -o=jsonpath='{.users[*].name}' > /opt/outputs/users.txt

kubectl get pv --sort-by='{.items[*].spec.capacity}' > /opt/outputs/storage-capacity-sorted.txt
kubectl get pv -o=jsonpath='{.items[*].spec.capacity.storage}'
kubectl get pv --sort-by=.spec.capacity.storage > /opt/outputs/storage-capacity-sorted.txt
kubectl get pv -o=custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage > /opt/outputs/pv-and-capacity-sorted.txt
kubectl get pv --sort-by=.spec.capacity.storage -o=custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage > /opt/outputs/pv-and-capacity-sorted.txt

kubectl get pv --sort-by=.spec.capacity.storage -o=custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage > /opt/outputs/pv-and-capacity-sorted.txt
# That was good, but we don't need all the extra details. Retrieve just the first 2 columns of output 
# and store it in 
/opt/outputs/pv-and-capacity-sorted.txt
# The columns should be named NAME and CAPACITY. Use the custom-columns option. 
# And remember it should still be sorted as in the previous question.

# A set of Persistent Volumes are available. Sort them based on their capacity and store the result in the file 
/opt/outputs/storage-capacity-sorted.txt

# A kube-config file is present at /root/my-kube-config. Get the user names from it and store it in a file /opt/outputs/users.txt
# Use the command 
kubectl config view --kubeconfig=/root/my-kube-config 
# to view the custom kube-config

# Use JSON PATH query to retrieve the osImages of all the nodes and store it in a file /opt/outputs/nodes_os.txt
# The osImages are under the nodeInfo section under status of each node.

# Use JSON PATH query to fetch node names and store them in /opt/outputs/node_names.txt

kubectl get nodes -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\n"}'
kubectl get nodes -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\n"}{end}'
kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{\"\t\"}{.status.startTime}{\"\n\"}{end}"
kubectl get nodes -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{"\n"}{end}'
kubectl get nodes -o=jsonpath='{range .items[*]}{..}{"\t"}{"\n"}{end}'
kubectl get nodes -o=jsonpath='{range .items[?(@.metadata.name == "node01")]}'
kubectl get nodes -o=jsonpath='{range .items[?(@.metadata.name == "node01")].spec.taints[*]}'
kubectl get nodes -o=jsonpath='{.items[?(@.metadata.name == "node01")].spec.taints[*]}{"\n"}'
kubectl get nodes -o=jsonpath='{.items[?(@.metadata.name == "node01")]}{"\n"}'
kubectl get nodes -o=jsonpath='{.items[?(@.metadata.name == "node01")]}' > /opt/outputs/node01.json # mess
kubectl get nodes -o=jsonpath='{.items[?(@.metadata.name == "node01")]}' > /opt/outputs/node01.json
# /opt/outputs/nodes.json
# {.items[*]}
# '{.status.startTime}'
# "['metadata.name', 'status.capacity']}"
# /opt/outputs/node01.json

{.users[?(@.name=="e2e")].user.password}

kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'

kubectl get nodes -o=jsonpath='{.items[1]}'
kubectl get nodes -o=jsonpath='{@}'
kubectl get nodes -o=jsonpath='{.items[0].metadata.name}'
kubectl get nodes -o=jsonpath='{.items[1].metadata.name}'
kubectl get nodes -o=jsonpath="{.items[*]['metadata.name', 'status.capacity']}"





