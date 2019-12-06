### Networking
~~~sh
cat /etc/hosts
cat /etc/resolv.conf
~~~

## Provisioning should be less hard!!!
make some scripts for this
### Samples
~~~sh
ping -a
# 
dig
host
nslookup
#
for i in {1..10}; do <command>; done;
#
for i in {1..10}; do kubectl get pods && sleep 1; done;
# backup file - rename 
mv <path_to/file>{,.back}
#
ssh -F config-ssh.txt master-1 mkdir /root/vagrant/.keys && \
scp -F config-ssh.txt  C:/Users/User77/Desktop/custom/vagrant/.vagrant/ master-1:/root/vagrant/.keys/
# piece of shit
scp -r /path/to/local/source user@ssh.example.com:/path/to/remote/destination
#
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
~~~


### Links
[HA proxy Habr](https://habr.com/ru/company/southbridge/blog/439562/)