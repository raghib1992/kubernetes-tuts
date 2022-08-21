
# From User side
##  Create key for john by user John
```
openssl genrsa -out john.key 2048
```
## certificate sighning request by user John
```
openssl req -new -key john.key -subj "/CN=john/O=finance" -out john.csr
```
## base64 encode of csr file
```
cat nadim.csr | base64 | tr -d "\n"
```
# From Admin Side
# Creating a namespce for user to get access of that ns only.
```
kubectl get ns
kubectl create ns finance
```
### admin take the key and create a certificate signing request object
#### object created by manifest file
#### nadim-csr.yaml
```
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john-csr
spec:
  request: < cat nadim.csr | base 64 >
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 864000  # one day
  usages:
  - client auth
```

### status of the obejct seem by admin by
```
kubectl get csr
```
### Approve the request
```
kubectl certificate approve <csr name> 
```
### view the certificate
```
kubectl get csr <name csr> -o yaml
```
## get john.crt
```
kubectl get csr john-csr -o jsonpath='{.status.certificate}' | base64 --decode > bob.crt
```
## edit config file with base64 crt file and key for new user
## Create role and rolebindings
## share the kubeconfig file with the user
*************************************************************************************
kubectl config set-credentials john --client-certificate=john.crt --client-key=john.key

kubectl config view


kubectl auth can-i list pods -n finance

************************************************
## get ca.key and ca.crt in working dir
```
cp /etc/kubernetes/pki/ca.{crt,key} .
```
## Create Signing Request
```
openssl x509 -req -in john.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out john.crt -days 365
```
or 
## alternatively CertificateSingingRequest
yaml file
```

```
*******************************************
Get user key and csr file and Create kubeconfig file that John can access kubeneters cluster and send to hum
********************************************

kubectl --kubeconfig john.kubeconfig config set-cluster --server https://172.31.40.209:6443 --certificate-authority=ca.crt

# Add user to kubeconfig file
kubectl --kubeconfig john.kubeconfig config set-dredentials john --client-certificate /home/john/john.crt --client-key /home/john/john.key

# Ste the context
kubectl --kubeconfig john.kubeconfig config set-context john-kubernetes --cluster kubernetes --namespace finance --user john 

******
On master side

edit kubeconfig for username, namespace, context
create role for user
create rolebinding 


****************
kubectl config view -o jsonpath='{"cluster name\tServer\n"}{range.clusters[*]}{.name}{"\t"}{.cluster.server}{"\n"}{end}'

export CLUSTER_NAME="kubernetes"

APISERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$CLUSTER_NAME\")].cluster.server}")

TOKEN=$(kubectl get secret -n kube-system -o jsonpath="{.items[?(@.matadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 -D)