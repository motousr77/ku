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
Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
      --attach=false: If true, wait for the Pod to start running, and then attach to the Pod as if 'kubectl attach ...' were called.  Default false, unless '-i/--stdin' is set, in which case the default is true. With '--restart=Never' the exit code of the container process is returned.
      --cascade=true: If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a ReplicationController).  Default true.
      --command=false: If true and extra arguments are present, use them as the 'command' field in the container, rather than the 'args' field which is the default.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --env=[]: Environment variables to set in the container
      --expose=false: If true, a public, external service is created for the container(s) which are run
  -f, --filename=[]: to use to replace the resource.
      --force=false: Only used when grace-period=0. If true, immediately remove resources from API and bypass graceful deletion. Note that immediate deletion of some resources may result in inconsistency or data loss and requires confirmation.
      --generator='': The name of the API generator to use, see http://kubernetes.io/docs/user-guide/kubectl-conventions/#generators for a list.
      --grace-period=-1: Period of time in seconds given to the resource to terminate gracefully. Ignored if negative. Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).
      --hostport=-1: The host port mapping for the container port. To demonstrate a single-machine container.
      --image='': The image for the container to run.
      --image-pull-policy='': The image pull policy for the container. If left empty, this value will not be specified by the client and defaulted by the server
  -k, --kustomize='': Process a kustomization directory. This flag can not be used together with -f or -R.
  -l, --labels='': Comma separated labels to apply to the pod(s). Will override previous values.
      --leave-stdin-open=false: If the pod is started in interactive mode or with stdin, leave stdin open after the first attach completes. By default, stdin will be closed after the first attach completes.
      --limits='': The resource requirement limits for this container.  For example, 'cpu=200m,memory=512Mi'.  Note that server side components may assign limits depending on the server configuration, such as limit ranges.
  -o, --output='': Output format. One of: json|yaml|name|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-file.
      --overrides='': An inline JSON override for the generated object. If this is non-empty, it is used to override the generated object. Requires that the object supply a valid apiVersion field.
      --pod-running-timeout=1m0s: The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running
      --port='': The port that this container exposes.  If --expose is true, this is also the port used by the service that is created.
      --quiet=false: If true, suppress prompt messages.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
  -r, --replicas=1: Number of replicas to create for this container. Default is 1.
      --requests='': The resource requirement requests for this container.  For example, 'cpu=100m,memory=256Mi'.  Note that server side components may assign requests depending on the server configuration, such as limit ranges.
      --restart='Always': The restart policy for this Pod.  Legal values [Always, OnFailure, Never].  If set to 'Always' a deployment is created, if set to 'OnFailure' a job is created, if set to 'Never',a regular pod is created. For the latter two --replicas must be 1.  Default 'Always', for CronJobs `Never`.
      --rm=false: If true, delete resources created in this command for attached containers.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
      --schedule='': A schedule in the Cron format the job should be run with.
      --service-generator='service/v2': The name of the generator to use for creating a service.  Only used if --expose is true
      --service-overrides='': An inline JSON override for the generated service object. If this is non-empty, it is used to override the generated object. Requires that the object supply a valid apiVersion field.  Only used if --expose is true.
      --serviceaccount='': Service account to set in the pod spec
  -i, --stdin=false: Keep stdin open on the container(s) in the pod, even if nothing is attached.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --timeout=0s: The length of time to wait before giving up on a delete, zero means determine a timeout from the size of the object
  -t, --tty=false: Allocated a TTY for each container in the pod.
      --wait=false: If true, wait for resources to be gone before returning. This waits for finalizers.
Usage:
  kubectl run NAME --image=image [--env="key=value"] [--port=port] [--replicas=replicas] [--dry-run=bool] [--overrides=inline-json] [--command] -- [COMMAND] [args...] [options]
Use "kubectl options" for a list of global command-line options (applies to all commands).
