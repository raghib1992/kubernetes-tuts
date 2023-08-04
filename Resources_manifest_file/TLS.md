# TLS certificate generarion
## Different tools available
```
EASYRSA
OPENSSL
CFSSL
```
## how to use the certificate
### api call
```
curl https://kube-apiserver:6443/api/v1/pods \
    --key admin.key \
    --cert admin.crt \
    --cacert ca.crt
```
### config file
```
apiVersion: v1
cluster:
- cluster:
    certificate-authority: ca.crt
    server: https://kube-apiserver:6443
  name: kubernetes
kind: Config
users:
- name: kubernetes-admin
  user:
    client-certificate: admin.crt
    client-key: admin.key
```

## OPENSSL to generate TLS certificate
### CA
#### Generate Keys for CA
```
openssl genrsa -out ca.key2048
```
#### Certificate Signing request
```
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
```
#### Sign Certificates
```
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
```
#### One copy of ca.crt will have by all k8s components
### Client side
#### Generate Keys for Admin # add to group SYSTEM:MASTERS
```
openssl genrsa -out admin.key 2048
```
#### Certificate Signing request
```
openssl req -new -key admin.key -subj "/CN=kube-admin" -out admin.csr
```
#### Sign Certificates
```
openssl x509 -req -in admin.csr -CA ca.crt -CAKey ca.key -out admin.crt
```

#### Similarly for kube-scheduler <name=SYSTEM:KUBE-SCHEDULER> (scheduler.crt, scheduler.csr, scheduler.key)
#### similarly for kube controller manager <name=SYSTEM:KUBE-CONTROLLER-MANAGER> (controller-manager.key controller-manager.crt controller-manager.csr)
#### Similarly for kube-proxy (kube-proxy.key kube-proxy.crt kube-proxy.csr)

### Server side
#### ETCD
##### similarly for ETCD (ETCD.key ETCD.crt ETCD.csr)
##### ETCD is deploy as cluster, to communicate between ETCD server. etcdpeer crt and key also required
##### mention the etcd and peer certificate
###### etcd.yaml
```
- --key-file=/path-to-certs/etcdserver.key
- --cert-file=/path-to-certs/etcdserver.crt
- --peer-cert-file=/path-to-certs/etcdpeer1.crt
- --peer-client-cert-auth=true
- --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
- --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
- --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
```
#### kube-apiserver
##### generate key
```
openssl genrsa -out apiserver.key 2048
```
#### CSR
##### config file for alternate name
##### openssl.cnf
```
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation,
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.96.0.1
IP.2 = 172.17.0.87
```
```
openssl req -new -key apiserver.key -subj \
"/CN=kube-apiserver" -out apiserver.csr -config openssl.cnf
```
### certificate
```
openssl x509 -req -in apiserver.csr \
    -CA ca.key -CAKey ca.key -out apiserver.crt
```
###
#### 1. CA file passes in
#### 2. api server crt
#### 3. client crt connect with etcd 
#### 4. client crt to connect with kubelet
```
ExecStart=/usr/local/bin/kube-apiserver \\
--etcd-cafile=/var/lib/kubernetes/ca.pem \\
--etcd-certfile=/var/lib/kubernetes/apiserver-etcd-client.crt \\
--etcd-keyfile=/var/lib/kubernetes/apiserver-etcd-client.key \\
--kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \\
--kubelet-client-certificate=/var/lib/kubernetes/apiserver-etcd-client.crt \\
--kubelet-client-key=/var/lib/kubernetes/apiserver-etcd-client.key \\
--client-ca-file=/var/lib/kubernetes/ca.pem \\
--tls-cert-file=/var/lib/kubernetes/apiserver.crt \\
--tls-private-key-file=/var/lib/kubernetes/apiserver.key \\
```
#### kubelet
##### similarly create key and crt for kubelet but name should be node name
#### specify in the kubelet config
#### kubelet-config.yaml
```
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
x509:
clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
- "10.32.0.10"
podCIDR: "${POD_CIDR}"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/node01.crt"
tlsPrivateKeyFile: "/var/lib/kubelet/node01.key"
```
### also client crt to authenticate kube-apiserver
#### create certificate with system:node:<nodename>
#### added to group name system:nodes 
****************************************************
# To view Certificate
## If you create the cluster by scratch
### you had to create all the certificate by yourself
```
cat /etc/systemd/system/kube-apiserver.service
```
## if you create the cluster by kubeadm tool
```
cat /etc/kubernetes/manifests/kube-apiserver.yaml
```
### get the list of the key and certificate file used by apiserver
### command to decode the key and certificate to see the detials
```
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout
```
### do similarly for other components
***************************
# To view logs
## cluster by scratch
```
journalctl -u etcd.service -l
```
## cluster by kubeadm
```
kubectl logs etcd-master
```
## when kube-apiserver nad ETCd server down, then kubectl command should not work, then
```
docker ps -a
docker logs <container-id>
```