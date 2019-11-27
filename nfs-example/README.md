---
https://hub.docker.com/r/cpuguy83/nfs-server/
---
Now, check that the NFS volume works.
nfs ⟩ kubectl exec -it pod-use-nfs sh
/ # cat /var/nfs/dates.txt
Mon Oct 22 00:47:36 UTC 2018
Mon Oct 22 00:47:41 UTC 2018
Mon Oct 22 00:47:46 UTC 2018



nfs ⟩ kubectl exec -it nfs-svc-pod sh
# cat /exports/dates.txt
Mon Oct 22 00:47:36 UTC 2018
Mon Oct 22 00:47:41 UTC 2018
Mon Oct 22 00:47:46 UTC 2018
---
source: https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-volumes-example-nfs-persistent-volume.html
---
- https://github.com/matthewpalmer?tab=repositories