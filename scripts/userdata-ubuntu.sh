#!/bin/bash
set -x

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

#add additional keepalive seconds to sshd
echo "ClientAliveInterval 1200" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax  3" >> /etc/ssh/sshd_config
#sed -i -E 's/#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

apt-get update -y
apt-get upgrade -y

apt-get -y install net-tools nmap unzip jq golang golang-go python3-pip python3-venv docker docker-compose awscli nfs-common binutils
export PATH=$PATH:/usr/local/go/bin
systemctl enable docker
systemctl start docker
usermod -aG docker azuser


apt-get -y install bash-completion
source /etc/profile.d/bash_completion.sh
echo "export PROMPT_COMMAND='history -a'" >> /etc/bashrc


#install aws cli version2
# just in case apt-get fails to install
if [ -x "$(command -v aws)" ]; then
    echo "AWS CLI is already installed."
else
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
fi


#install kubectl

apt-get install -y apt-transport-https
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl