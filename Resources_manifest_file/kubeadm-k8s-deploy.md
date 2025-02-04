# Steps
#### 1. Create Node
- Create node for worker node and master as per your requirement (ubuntu)
#### 2. Istall Dockere in all the nodes
#### 3. Install kubeadm tool in all the node
#### 4. Initialize the master server
- All the required components are installed during this process
#### 5. Creat POD network between master and worker node
#### 6. Join the master node with worker node

#### Ref
- *https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/*
*****************************************

## 1. Verify the MAC address and product_uuid are unique for every node
#### Letting iptables see bridge traffic
```sh
ip a
#The product_uuid can be checked by using the command 
sudo cat /sys/class/dmi/id/product_uuid
```
#### Check required ports
```sh
nc 127.0.0.1 6443 -v
```

## 2. Install Kubeadm kubelet and kubectl on all nodes
1. Update the apt package index and install packages needed to use the Kubernetes apt repository:
```sh
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
```
2. Download the public signing key for the Kubernetes package repositories. The same signing key is used for all repositories so you can disregard the version in the URL:
```sh
# If the directory `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```
##### **Note**: In releases older than Debian 12 and Ubuntu 22.04, directory /etc/apt/keyrings does not exist by default, and it should be created before the curl command.

3. Add the appropriate Kubernetes apt repository. Please note that this repository have packages only for Kubernetes 1.32; for other Kubernetes minor versions, you need to change the Kubernetes minor version in the URL to match your desired minor version (you should also check that you are reading the documentation for the version of Kubernetes that you plan to install).
```sh
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

4. Update the apt package index, install kubelet, kubeadm and kubectl, and pin their version:
```sh
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Verify kubeadm version
kubeadm version
```

5. (Optional) Enable the kubelet service before running kubeadm:
```sh
sudo systemctl enable --now kubelet
```

## 3. Install Container Runtime in all the nodes
#### Install containerd
```sh
sudo apt update
sudo apt install -y containerd
```
#### Install Docker

## 4. Configuring a cgroup driver
### Check the current configure cgroup
```sh
ps -p 1
```
#### Use the current using cgroup either systemd or cgroufs
#### Note: In v1.22 and later, if the user does not set the cgroupDriver field under KubeletConfiguration, kubeadm defaults it to systemd. In Kubernetes v1.28, you can enable automatic detection of the cgroup driver as an alpha feature. See systemd cgroup driver for more details.
#### Hence we not implement this step

#### 1. kubeadm-config.yaml
```yml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta4
kubernetesVersion: v1.21.0
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
```
#### 2. Such a configuration file can then be passed to the kubeadm command:
```sh
kubeadm init --config kubeadm-config.yaml
```

### Configuring the systemd cgroup driver
#### 1. Create folder 
```
sudo mkdir -p /etc/containerd/
```
#### 2. check default config 
```sh
containerd config default
```
#### 3. To use the systemd cgroup driver in /etc/containerd/config.toml with runc, set
```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```

```sh
containerd confi g default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml
```

#### 4. restart systemd
```sh
sudo systemctl restart containerd
```
#### 5. verify
```sh
cat /etc/containerd/config.toml | grep -i SystemdCgroup -B 50
```

## 5. Initialize control-plane
```sh
sudo kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address <ip add of master node>

sudo kubeadm init --pod-network-cidr "10.244.0.0/16" --apiserver-advertise-address 172.31.24.74 --cri-socket unix:///var/run/containerd/containerd.sock --upload-creds
```
## 6. get config file
```
cat /etc/kubernetes/admin.conf
```

## 7. locally add file
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

*******************************
#### load br_netfilter module in all the nodes
```sh
lsmod | grep br_netfilter
sudo modprobe br_netfilter
```
#### create new kernel paramter in all the nodes
```sh
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
```



 all nodes
#### Ref - *https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/*

```t
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=test-cluster
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
```
#### Set SELinux in permissive mode (effectively disabling it) on all node
```sh
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```

# Post installation task only on master

## To start using your cluster, you need to run the following as a regular user:
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```


## Alternatively, if you are the root user, you can run:
```
export KUBECONFIG=/etc/kubernetes/admin.conf
```

## You should now deploy a pod network to the cluster.

## Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  ### Ref -https://kubernetes.io/docs/concepts/cluster-administration/addons/
```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```


# to join woker node - run on all the worker nodes
## Then you can join any number of worker nodes by running the following on each as root:
```
kubeadm join 172.31.38.189:6443 --token gac0l3.8lhxf2aaukjue14z \
        --discovery-token-ca-cert-hash sha256:fab0ba8ee4a72e6ae7bb9c3171cef14fcabe1853e42d6c525975029a5a0acc78
```

### For Centos if tc command not found
```
yum install -y iproute-tc
```

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
************************************

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
**********************************************************
# Install Pod Network Section
## weave
### Ref https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```