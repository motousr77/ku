###### try to deploy some app
~~~sh
# create deploy
kubectl run nginx-tmp --image=nginx:alpine --port=80 --replicas=2
# then expose service
cat <<EOF | kubectl apply -f -
$(kubectl expose deployment nginx-tmp --name=nginx-tmp-svc --type=NodePort \
--port=80 --target-port=8080 --protocol=TCP -o json)
EOF
~~~
~~~sh
cat <<EOF | kubectl create -f --sace-config -
$(kubectl expose deployment nginx-tmp --name=nginx-tmp-svc --type=NodePort \
--port=80 --target-port=8080 --protocol=TCP -o json)
EOF
~~~
