apt-get update

apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
     sudo

sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
# sudo apt-get install docker-ce
# sudo apt-cache madison docker-ce

sudo apt-get install docker-ce=17.09.1~ce-0~debian

sudo docker run hello-world