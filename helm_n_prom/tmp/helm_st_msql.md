 <!-- helm show all stable/mysql -->
apiVersion: v1
appVersion: 5.7.27
description: Fast, reliable, scalable, and easy to use open-source relational database
  system.
home: https://www.mysql.com/
icon: https://www.mysql.com/common/logos/logo-mysql-170x115.png
keywords:
- mysql
- database
- sql
maintainers:
- email: o.with@sportradar.com
  name: olemarkus
- email: viglesias@google.com
  name: viglesiasce
name: mysql
sources:
- https://github.com/kubernetes/charts
- https://github.com/docker-library/mysql
version: 1.6.0

---
## mysql image version
## ref: https://hub.docker.com/r/library/mysql/tags/
##
image: "mysql"
imageTag: "5.7.14"

strategy:
  type: Recreate

busybox:
  image: "busybox"
  tag: "1.29.3"

testFramework:
  enabled: true
  image: "dduportal/bats"
  tag: "0.4.0"

## Specify password for root user
##
## Default: random 10 character string
# mysqlRootPassword: testing

## Create a database user
##
# mysqlUser:
## Default: random 10 character string
# mysqlPassword:

## Allow unauthenticated access, uncomment to enable
##
# mysqlAllowEmptyPassword: true

## Create a database
##
# mysqlDatabase:

## Specify an imagePullPolicy (Required)
## It's recommended to change this to 'Always' if the image tag is 'latest'
## ref: http://kubernetes.io/docs/user-guide/images/#updating-images
##
imagePullPolicy: IfNotPresent

## Additionnal arguments that are passed to the MySQL container.
## For example use --default-authentication-plugin=mysql_native_password if older clients need to
## connect to a MySQL 8 instance.
args: []

extraVolumes: |
  # - name: extras
  #   emptyDir: {}

extraVolumeMounts: |
  # - name: extras
  #   mountPath: /usr/share/extras
  #   readOnly: true

extraInitContainers: |
  # - name: do-something
  #   image: busybox
  #   command: ['do', 'something']

# Optionally specify an array of imagePullSecrets.
# Secrets must be manually created in the namespace.
# ref: https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod
# imagePullSecrets:
  # - name: myRegistryKeySecretName

## Node selector
## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
nodeSelector: {}

## Tolerations for pod assignment
## Ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
##
tolerations: []

livenessProbe:
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 3

readinessProbe:
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 1
  successThreshold: 1
  failureThreshold: 3

## Persist data to a persistent volume
persistence:
  enabled: true
  ## database data Persistent Volume Storage Class
  ## If defined, storageClassName: <storageClass>
  ## If set to "-", storageClassName: "", which disables dynamic provisioning
  ## If undefined (the default) or set to null, no storageClassName spec is
  ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
  ##   GKE, AWS & OpenStack)
  ##
  # storageClass: "-"
  accessMode: ReadWriteOnce
  size: 8Gi
  annotations: {}

## Use an alternate scheduler, e.g. "stork".
## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
##
# schedulerName:

## Security context
securityContext:
  enabled: false
  runAsUser: 999
  fsGroup: 999

## Configure resource requests and limits
## ref: http://kubernetes.io/docs/user-guide/compute-resources/
##
resources:
  requests:
    memory: 256Mi
    cpu: 100m

# Custom mysql configuration files path
configurationFilesPath: /etc/mysql/conf.d/

# Custom mysql configuration files used to override default mysql settings
configurationFiles: {}
#  mysql.cnf: |-
#    [mysqld]
#    skip-name-resolve
#    ssl-ca=/ssl/ca.pem
#    ssl-cert=/ssl/server-cert.pem
#    ssl-key=/ssl/server-key.pem

# Custom mysql init SQL files used to initialize the database
initializationFiles: {}
#  first-db.sql: |-
#    CREATE DATABASE IF NOT EXISTS first DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
#  second-db.sql: |-
#    CREATE DATABASE IF NOT EXISTS second DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

metrics:
  enabled: false
  image: prom/mysqld-exporter
  imageTag: v0.10.0
  imagePullPolicy: IfNotPresent
  resources: {}
  annotations: {}
    # prometheus.io/scrape: "true"
    # prometheus.io/port: "9104"
  livenessProbe:
    initialDelaySeconds: 15
    timeoutSeconds: 5
  readinessProbe:
    initialDelaySeconds: 5
    timeoutSeconds: 1
  flags: []
  serviceMonitor:
    enabled: false
    additionalLabels: {}

## Configure the service
## ref: http://kubernetes.io/docs/user-guide/services/
service:
  annotations: {}
  ## Specify a service type
  ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services---service-types
  type: ClusterIP
  port: 3306
  # nodePort: 32000
  # loadBalancerIP:

## Pods Service Account
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
serviceAccount:
  ## Specifies whether a ServiceAccount should be created
  ##
  create: false
  ## The name of the ServiceAccount to use.
  ## If not set and create is true, a name is generated using the mariadb.fullname template
  # name:

ssl:
  enabled: false
  secret: mysql-ssl-certs
  certificates:
#  - name: mysql-ssl-certs
#    ca: |-
#      -----BEGIN CERTIFICATE-----
#      ...
#      -----END CERTIFICATE-----
#    cert: |-
#      -----BEGIN CERTIFICATE-----
#      ...
#      -----END CERTIFICATE-----
#    key: |-
#      -----BEGIN RSA PRIVATE KEY-----
#      ...
#      -----END RSA PRIVATE KEY-----

## Populates the 'TZ' system timezone environment variable
## ref: https://dev.mysql.com/doc/refman/5.7/en/time-zone-support.html
##
## Default: nil (mysql will use image's default timezone, normally UTC)
## Example: 'Australia/Sydney'
# timezone:

# Deployment Annotations
deploymentAnnotations: {}

# To be added to the database server pod(s)
podAnnotations: {}
podLabels: {}

## Set pod priorityClassName
# priorityClassName: {}


## Init container resources defaults
initContainer:
  resources:
    requests:
      memory: 10Mi
      cpu: 10m

---
# MySQL

[MySQL](https://MySQL.org) is one of the most popular database servers in the world. Notable users include Wikipedia, Facebook and Google.

## Introduction

This chart bootstraps a single node MySQL deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.10+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mysql
```

The command deploys MySQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

By default a random password will be generated for the root user. If you'd like to set your own password change the mysqlRootPassword
in the values.yaml.

You can retrieve your root password by running the following command. Make sure to replace [YOUR_RELEASE_NAME]:

    printf $(printf '\%o' `kubectl get secret [YOUR_RELEASE_NAME]-mysql -o jsonpath="{.data.mysql-root-password[*]}"`)

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release completely.

## Configuration

The following table lists the configurable parameters of the MySQL chart and their default values.

| Parameter                                    | Description                                                                                  | Default                                              |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `args`                                       | Additional arguments to pass to the MySQL container.                                         | `[]`                                                 |
| `initContainer.resources`                    | initContainer resource requests/limits                                                       | Memory: `10Mi`, CPU: `10m`                           |
| `image`                                      | `mysql` image repository.                                                                    | `mysql`                                              |
| `imageTag`                                   | `mysql` image tag.                                                                           | `5.7.14`                                             |
| `busybox.image`                              | `busybox` image repository.                                                                  | `busybox`                                            |
| `busybox.tag`                                | `busybox` image tag.                                                                         | `1.29.3`                                             |
| `testFramework.enabled`                      | `test-framework` switch.                                                                     | `true`                                               |
| `testFramework.image`                        | `test-framework` image repository.                                                           | `dduportal/bats`                                     |
| `testFramework.tag`                          | `test-framework` image tag.                                                                  | `0.4.0`                                              |
| `imagePullPolicy`                            | Image pull policy                                                                            | `IfNotPresent`                                       |
| `existingSecret`                             | Use Existing secret for Password details                                                     | `nil`                                                |
| `extraVolumes`                               | Additional volumes as a string to be passed to the `tpl` function                            |                                                      |
| `extraVolumeMounts`                          | Additional volumeMounts as a string to be passed to the `tpl` function                       |                                                      |
| `extraInitContainers`                        | Additional init containers as a string to be passed to the `tpl` function                    |                                                      |
| `mysqlRootPassword`                          | Password for the `root` user. Ignored if existing secret is provided                         | Random 10 characters                                 |
| `mysqlUser`                                  | Username of new user to create.                                                              | `nil`                                                |
| `mysqlPassword`                              | Password for the new user. Ignored if existing secret is provided                            | Random 10 characters                                 |
| `mysqlDatabase`                              | Name for new database to create.                                                             | `nil`                                                |
| `livenessProbe.initialDelaySeconds`          | Delay before liveness probe is initiated                                                     | 30                                                   |
| `livenessProbe.periodSeconds`                | How often to perform the probe                                                               | 10                                                   |
| `livenessProbe.timeoutSeconds`               | When the probe times out                                                                     | 5                                                    |
| `livenessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed. | 1                                                    |
| `livenessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 3                                                    |
| `readinessProbe.initialDelaySeconds`         | Delay before readiness probe is initiated                                                    | 5                                                    |
| `readinessProbe.periodSeconds`               | How often to perform the probe                                                               | 10                                                   |
| `readinessProbe.timeoutSeconds`              | When the probe times out                                                                     | 1                                                    |
| `readinessProbe.successThreshold`            | Minimum consecutive successes for the probe to be considered successful after having failed. | 1                                                    |
| `readinessProbe.failureThreshold`            | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 3                                                    |
| `schedulerName`                              | Name of the k8s scheduler (other than default)                                               | `nil`                                                |
| `persistence.enabled`                        | Create a volume to store data                                                                | true                                                 |
| `persistence.size`                           | Size of persistent volume claim                                                              | 8Gi RW                                               |
| `persistence.storageClass`                   | Type of persistent volume claim                                                              | nil                                                  |
| `persistence.accessMode`                     | ReadWriteOnce or ReadOnly                                                                    | ReadWriteOnce                                        |
| `persistence.existingClaim`                  | Name of existing persistent volume                                                           | `nil`                                                |
| `persistence.subPath`                        | Subdirectory of the volume to mount                                                          | `nil`                                                |
| `persistence.annotations`                    | Persistent Volume annotations                                                                | {}                                                   |
| `nodeSelector`                               | Node labels for pod assignment                                                               | {}                                                   |
| `tolerations`                                | Pod taint tolerations for deployment                                                         | {}                                                   |
| `metrics.enabled`                            | Start a side-car prometheus exporter                                                         | `false`                                              |
| `metrics.image`                              | Exporter image                                                                               | `prom/mysqld-exporter`                               |
| `metrics.imageTag`                           | Exporter image                                                                               | `v0.10.0`                                            |
| `metrics.imagePullPolicy`                    | Exporter image pull policy                                                                   | `IfNotPresent`                                       |
| `metrics.resources`                          | Exporter resource requests/limit                                                             | `nil`                                                |
| `metrics.livenessProbe.initialDelaySeconds`  | Delay before metrics liveness probe is initiated                                             | 15                                                   |
| `metrics.livenessProbe.timeoutSeconds`       | When the probe times out                                                                     | 5                                                    |
| `metrics.readinessProbe.initialDelaySeconds` | Delay before metrics readiness probe is initiated                                            | 5                                                    |
| `metrics.readinessProbe.timeoutSeconds`      | When the probe times out                                                                     | 1                                                    |
| `metrics.flags`                              | Additional flags for the mysql exporter to use                                               | `[]`                                                 |
| `metrics.serviceMonitor.enabled`             | Set this to `true` to create ServiceMonitor for Prometheus operator                          | `false`                                              |
| `metrics.serviceMonitor.additionalLabels`    | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus        | `{}`                                                 |
| `resources`                                  | CPU/Memory resource requests/limits                                                          | Memory: `256Mi`, CPU: `100m`                         |
| `configurationFiles`                         | List of mysql configuration files                                                            | `nil`                                                |
| `configurationFilesPath`                     | Path of mysql configuration files                                                            | `/etc/mysql/conf.d/`                                 |
| `securityContext.enabled`                    | Enable security context (mysql pod)                                                          | `false`                                              |
| `securityContext.fsGroup`                    | Group ID for the container (mysql pod)                                                       | 999                                                  |
| `securityContext.runAsUser`                  | User ID for the container (mysql pod)                                                        | 999                                                  |
| `service.annotations`                        | Kubernetes annotations for mysql                                                             | {}                                                   |
| `service.type`                               | Kubernetes service type                                                                      | ClusterIP                                            |
| `service.loadBalancerIP`                     | LoadBalancer service IP                                                                      | `""`                                                 |
| `serviceAccount.create`                      | Specifies whether a ServiceAccount should be created                                         | `false`                                              |
| `serviceAccount.name`                        | The name of the ServiceAccount to create                                                     | Generated using the mysql.fullname template          |
| `ssl.enabled`                                | Setup and use SSL for MySQL connections                                                      | `false`                                              |
| `ssl.secret`                                 | Name of the secret containing the SSL certificates                                           | mysql-ssl-certs                                      |
| `ssl.certificates[0].name`                   | Name of the secret containing the SSL certificates                                           | `nil`                                                |
| `ssl.certificates[0].ca`                     | CA certificate                                                                               | `nil`                                                |
| `ssl.certificates[0].cert`                   | Server certificate (public key)                                                              | `nil`                                                |
| `ssl.certificates[0].key`                    | Server key (private key)                                                                     | `nil`                                                |
| `imagePullSecrets`                           | Name of Secret resource containing private registry credentials                              | `nil`                                                |
| `initializationFiles`                        | List of SQL files which are run after the container started                                  | `nil`                                                |
| `timezone`                                   | Container and mysqld timezone (TZ env)                                                       | `nil` (UTC depending on image)                       |
| `podAnnotations`                             | Map of annotations to add to the pods                                                        | `{}`                                                 |
| `podLabels`                                  | Map of labels to add to the pods                                                             | `{}`                                                 |
| `priorityClassName`                          | Set pod priorityClassName                                                                    | `{}`                                                 |
| `deploymentAnnotations`                      | Map of annotations for deployment                                                            | `{}`                                                 |
| `strategy`                                   | Update strategy policy                                                                       | `{type: "Recreate"}`                                 |

Some of the parameters above map to the env variables defined in the [MySQL DockerHub image](https://hub.docker.com/_/mysql/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mysqlRootPassword=secretpassword,mysqlUser=my-user,mysqlPassword=my-password,mysqlDatabase=my-database \
    stable/mysql
```

The above command sets the MySQL `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mysql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [MySQL](https://hub.docker.com/_/mysql/) image stores the MySQL data and configurations at the `/var/lib/mysql` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality
you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

**Notice**: You may need to increase the value of `livenessProbe.initialDelaySeconds` when enabling persistence by using PersistentVolumeClaim from PersistentVolume with varying properties. Since its IO performance has impact on the database initialization performance. The default limit for database initialization is `60` seconds (`livenessProbe.initialDelaySeconds` + `livenessProbe.periodSeconds` * `livenessProbe.failureThreshold`). Once such initialization process takes more time than this limit, kubelet will restart the database container, which will interrupt database initialization then causing persisent data in an unusable state.

## Custom MySQL configuration files

The [MySQL](https://hub.docker.com/_/mysql/) image accepts custom configuration files at the path `/etc/mysql/conf.d`. If you want to use a customized MySQL configuration, you can create your alternative configuration files by passing the file contents on the `configurationFiles` attribute. Note that according to the MySQL documentation only files ending with `.cnf` are loaded.

```yaml
configurationFiles:
  mysql.cnf: |-
    [mysqld]
    skip-host-cache
    skip-name-resolve
    sql-mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
  mysql_custom.cnf: |-
    [mysqld]
```

## MySQL initialization files

The [MySQL](https://hub.docker.com/_/mysql/) image accepts *.sh, *.sql and *.sql.gz files at the path `/docker-entrypoint-initdb.d`.
These files are being run exactly once for container initialization and ignored on following container restarts.
If you want to use initialization scripts, you can create initialization files by passing the file contents on the `initializationFiles` attribute.


```yaml
initializationFiles:
  first-db.sql: |-
    CREATE DATABASE IF NOT EXISTS first DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
  second-db.sql: |-
    CREATE DATABASE IF NOT EXISTS second DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
```

## SSL

This chart supports configuring MySQL to use [encrypted connections](https://dev.mysql.com/doc/refman/5.7/en/encrypted-connections.html) with TLS/SSL certificates provided by the user. This is accomplished by storing the required Certificate Authority file, the server public key certificate, and the server private key as a Kubernetes secret. The SSL options for this chart support the following use cases:

* Manage certificate secrets with helm
* Manage certificate secrets outside of helm

## Manage certificate secrets with helm

Include your certificate data in the `ssl.certificates` section. For example:

```
ssl:
  enabled: false
  secret: mysql-ssl-certs
  certificates:
  - name: mysql-ssl-certs
    ca: |-
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
    cert: |-
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
    key: |-
      -----BEGIN RSA PRIVATE KEY-----
      ...
      -----END RSA PRIVATE KEY-----
```

> **Note**: Make sure your certificate data has the correct formatting in the values file.

## Manage certificate secrets outside of helm

1. Ensure the certificate secret exist before installation of this chart.
2. Set the name of the certificate secret in `ssl.secret`.
3. Make sure there are no entries underneath `ssl.certificates`.

To manually create the certificate secret from local files you can execute:
```
kubectl create secret generic mysql-ssl-certs \
  --from-file=ca.pem=./ssl/certificate-authority.pem \
  --from-file=server-cert.pem=./ssl/server-public-key.pem \
  --from-file=server-key.pem=./ssl/server-private-key.pem
```
> **Note**: `ca.pem`, `server-cert.pem`, and `server-key.pem` **must** be used as the key names in this generic secret.

If you are using a certificate your configurationFiles must include the three ssl lines under [mysqld]

```
[mysqld]
    ssl-ca=/ssl/ca.pem
    ssl-cert=/ssl/server-cert.pem
    ssl-key=/ssl/server-key.pem
```





# Helm Initialization
kubectl create serviceaccount promo --namespace kube-system
kubectl create clusterrolebinding promo-role-binding --clusterrole cluster-admin --serviceaccount=kube-system:promo
helm init --service-account promo
#
helm init --service-account promo --override spec.selector.matchLabels.'name'='promo',spec.selector.matchLabels.'app'='helm' --output yaml | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | kubectl apply -f -
#
helm init --service-account tiller --override spec.selector.matchLabels.'name'='tiller',spec.selector.matchLabels.'app'='helm' --output yaml | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | kubectl apply -f -
# Installing Prometheus Operator
helm install stable/prometheus-operator --version=4.3.6 --name=monitoring --namespace=monitoring --values=values_promo.yaml
~~~yaml
# values_promo.yaml
# Tested with stable/prometheus-operator v4.3.6
# https://medium.com/@eduardobaitello/trying-prometheus-operator-with-helm-promo-b617a2dccfa3
coreDns:
  service:
    selector:
      k8s-app: kube-dns

kubeControllerManager:
  service:
    selector:
      k8s-app: null
      component: kube-controller-manager

kubeEtcd:
  service:
    selector:
      k8s-app: null
      component: etcd

kubeScheduler:
  service:
    selector:
      k8s-app: null
      component: kube-scheduler

## Configuration for alertmanager
alertmanager:
  config:
    global:
      resolve_timeout: 5m
    route:
      group_by: ['job']
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 12h
      receiver: 'slack'
      routes:
      - match:
          alertname: Watchdog
        receiver: 'null'
    # This inhibt rule is a hack from: https://stackoverflow.com/questions/54806336/how-to-silence-prometheus-alertmanager-using-config-files/54814033#54814033
    inhibit_rules:
      - target_match_re:
           alertname: '.+Overcommit'
        source_match:
           alertname: 'Watchdog'
        equal: ['prometheus']
    receivers:
    - name: 'null'
    - name: 'slack'
      slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR_SLACK_WEBHOOK_HERE' # <--- REPLACE THIS WITH YOUR SLACK WEBHOOK
        send_resolved: true
        channel: '#notif-channel' # <--- REPLACE THIS WITH YOUR SLACK CHANNEL
        title: '[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] Monitoring Event Notification'
        text: |-
          {{ range .Alerts }}
            *Alert:* {{ .Labels.alertname }} - `{{ .Labels.severity }}`
            *Description:* {{ .Annotations.message }}
            *Graph:* <{{ .GeneratorURL }}|:chart_with_upwards_trend:> *Runbook:* <{{ .Annotations.runbook_url }}|:spiral_note_pad:>
            *Details:*
            {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
            {{ end }}
          {{ end }}