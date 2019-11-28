practice PVC
The application stores logs at location /log/app.log. View the logs.
kubectl exec -p webapp -ti sh
#
Configure a volume to store these logs at /var/log/webapp on the host
Use the spec given on the right.
  Name: webapp
  Image Name: kodekloud/event-simulator
  Volume HostPath: /var/log/webapp
  Volume Mount: /log 

cat > webapp-pod-hostpath-def.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: webapp
spec:
  containers:
  - name: event-simulator
    image: kodekloud/event-simulator
    env:
    - name: LOG_HANDLERS
      value: file
    volumeMounts:
    - mountPath: /log
      name: log-volume
  volumes:
  - name: log-volume
    hostPath:
      path: /var/log/webapp
      # this field is optional
      type: Directory
EOF
# ---
cat > pv-log-def.yaml << EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  accessModes:
    - ReadWriteMany
  capacity:
    storage: 100Mi
  hostPath:
    path: /pv/log
EOF
# ReadWriteMany !!!
cat > claim-log-1.yaml << EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: claim-log-1
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Mi
EOF
# kubectl get pv && kubectl get pvc && kubectl get pods
Update the webapp pod to use the persistent volume claim as its storage.
Replace hostPath configured earlier with the newly created PersistentVolumeClaim
View the answer file at /var/answers/webapp-pod-pvc.yaml
    Name: webapp
    Image Name: kodekloud/event-simulator
    Volume: PersistentVolumeClaim=claim-log-1
    Volume Mount: /log 

cat > webapp-new-def.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: webapp
spec:
  containers:
    - name: event-simulator
      image: kodekloud/event-simulator
      env:
      - name: LOG_HANDLERS
        value: file
      volumeMounts:
      - mountPath: /log
        name: log-volume
  volumes:
  - name: log-volume
    persistentVolumeClaim:
      claimName: claim-log-1
EOF
kubectl apply -f webapp-new-def.yaml



kubectl exec -it ubuntu-sleeper -- date -s '19 APR 2012 11:14:00'
#
containers:
  - name: _
    image:
    securityContext:
      capabilities:
        add:
          - SYS_TIME

# may delete after insert security cintent to container!
securityContext:
  runAsUser: 1010

#
kubectl get pod ubuntu-sleeper -o=jsonpath='{.spec.serviceAccount}'


master $ kubectl run --generator=run-pod/v1
Error: required flag(s) "image" not set
Examples:
  # Start a single instance of nginx.
  kubectl run nginx --image=nginx
  # Start a single instance of hazelcast and let the container expose port 5701 .
  kubectl run hazelcast --image=hazelcast --port=5701
  # Start a single instance of hazelcast and set environment variables "DNS_DOMAIN=cluster" and "POD_NAMESPACE=default" in the container.
  kubectl run hazelcast --image=hazelcast --env="DNS_DOMAIN=cluster" --env="POD_NAMESPACE=default"
  # Start a single instance of hazelcast and set labels "app=hazelcast" and "env=prod" in the container.
  kubectl run hazelcast --image=hazelcast --labels="app=hazelcast,env=prod"
  # Start a replicated instance of nginx.
  kubectl run nginx --image=nginx --replicas=5
  # Dry run. Print the corresponding API objects without creating them.
  kubectl run nginx --image=nginx --dry-run
  # Start a single instance of nginx, but overload the spec of the deployment with a partial set of values parsed from JSON.
  kubectl run nginx --image=nginx --overrides='{ "apiVersion": "v1", "spec": { ... } }'
  # Start a pod of busybox and keep it in the foreground, don't restart it if it exits.
  kubectl run -i -t busybox --image=busybox --restart=Never
  # Start the nginx container using the default command, but use custom arguments (arg1 .. argN) for that command.
  kubectl run nginx --image=nginx -- <arg1> <arg2> ... <argN>
  # Start the nginx container using a different command and custom arguments.
  kubectl run nginx --image=nginx --command -- <cmd> <arg1> ... <argN>
  # Start the perl container to compute π to 2000 places and print it out.
  kubectl run pi --image=perl --restart=OnFailure -- perl -Mbignum=bpi -wle 'print bpi(2000)'
  # Start the cron job to compute π to 2000 places and print it out every 5 minutes.
  kubectl run pi --schedule="0/5 * * * ?" --image=perl --restart=OnFailure -- perl -Mbignum=bpi -wle 'print bpi(2000)'
