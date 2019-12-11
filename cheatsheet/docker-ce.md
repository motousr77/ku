#### Docker CE installation
from: [https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
~~~sh
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
#
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#
sudo apt-key fingerprint 0EBFCD88
#
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
# sudo apt-cache policy docker-ce
# 18.06.3~ce~3-0~ubuntu
sudo apt update
sudo apt install docker-ce containerd.io

#
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
sudo apt update
sudo apt install docker-ce=18.06.3~ce~3-0~ubuntu containerd.io