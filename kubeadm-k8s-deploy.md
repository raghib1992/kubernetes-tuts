# Steps
## 1. Create Node
## 2. Istall Dockere in all the nodes
## 3. Install kubeadm tool in all the node
## 4. Initialize the master server
#### All the required components are installed during this process
## 5. Creat POD network between master and worker node
## 6. Join the master node with worker node
*****************************************
# Deploy Node on Virtual Mchine
## Using VMBox and Vagrant
### Prerequisite
#### Ref- https://www.youtube.com/watch?v=krDU3BtJNpk
#### Installed Virtual Box
#### Vagrant
```
vagrant status
vagrant up
vagrant ssh <node-name>
```
**************************************
# Install kubeadm
## Ref https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
## Letting iptables see bridged traffic
### to ensure br_netfilter is install on all nodes, run command
```
lsmod | grep br_netfilter
```
### if not install br-netfilter in all nodes
```
sudo modprobe br_netfilter
```
### create new kernel paramter
```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
```
************************************
# Installing runtime
## Ref https://kubernetes.io/docs/setup/production-environment/container-runtimes/
## become root user
```
sudo -i
```
## install docker on Ubuntu
### Ref: https://docs.docker.com/engine/install/ubuntu/
```
sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io
```
## configure docker
```
sudo mkdir /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
```
## restart and enable docker
```
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```
***********************************
# Install kubeadm, kubectl and kubelet
## for ubuntu
```
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl
```
**************************************************
# Configure kubeadm 
## Ref https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
## Creating a cluster using kubeadm
## Initializing your control-plane node
```
kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=172.31.37.12
```
## Become regular user
## run following command, as regular user
## get the admin.conf file and copy it to home dir of the user
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
## copy the command to join worker node to the cluster, run on each worker node
```
kubeadm join 65.1.145.154:6443 --token 6m8ty5.8w92yelljar81528 \
        --discovery-token-ca-cert-hash sha256:028aaabaa2a91a68b4991fb6cb8106ab105f1532ab36c40d12912bb5aace4058
```
**********************************************************
# Install Pod Network Section
## weave
### Ref https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```