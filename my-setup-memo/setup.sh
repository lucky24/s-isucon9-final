# upgrade
echo '********* init  *************'
cd
export LANGUAGE=python
sudo apt update
sudo apt upgrade -y
echo '********* end  *************'

# docker
echo '********* install DOCKER *************'
## preare installing docker
sudo apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

## install docker
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo docker run hello-world

## install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
echo '********* end *************'

# install golang
echo '************** install golang *****************'
wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
exec $SHELL -l
go version
echo '*************** end ***********************'

# setup ISUCON9-final
echo '****************** setup ISCON9 environment ******************'
git clone https://github.com/isucon/isucon9-final
cd ~/isucon9-final/webapp/frontend && sudo make
cd ~/isucon9-final/

sudo docker-compose -f webapp/docker-compose.yml -f webapp/docker-compose.${LANGUAGE}.yml build
sudo docker-compose -f webapp/docker-compose.yml -f webapp/docker-compose.${LANGUAGE}.yml up
echo '************************ end ****************************'
