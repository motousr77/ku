##### Version 1.0 alpha
## Understanding Kubernetes Architecture
##### Lesson Description:
The Kubernetes architecture has two main roles: the master role and the worker role. In this lesson, we will take a look at what each role is and the individual components that make it run. We will even deploy a pod to see the components in action!
~~~
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
EOF
~~~
Official Kubernetes Documentation: [Kubernetes Components Overview](https://kubernetes.io/docs/concepts/overview/components) API Server SchedulerControllerManager ectdDatastore kubelet kube-proxy Container Runtime

## Kubernetes API Primitives
##### Lesson Description:
Every component in the Kubernetes system makes a request to the API server. The kubectl command line utility processes those API calls for us and allows us to format our request in a certain way. In this lesson, we will learn how Kubernetes accepts the instructions to run deployments and go through the YAML script that is used to tell the control plane what our environment should look like.
~~~yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
~~~
[Spec and Status](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/#object-spec-and-status)
\
[API Versioning](https://kubernetes.io/docs/concepts/overview/kubernetes-api/#api-versioning) 
\
[Field Selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/)

