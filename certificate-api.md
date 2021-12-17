# Certificate API (certificate signing is automated through API)
## Create Certificate signing request
## Review Request
## Approve Request
## Share the certs to users
## Process
### Usergenerate key
```
openssl genrsa -out nadim.key 2048
```
### create CSR and send it to admin
```
openssl req -new -key nadim.key -subj "/CN=nadim" -out nadim.csr
```
### admin take the key and create acertificate signing request object
#### object created by manifest file
#### nadim-csr.yaml
```
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
    name: nadim
spec:
    groups:
    - system: authenticated
    usages:
    - digital signature
    - key enciphermen
    - server auth
    request:
      < cat nadim.csr | base 64 >
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
#### get the base 64 encoded cert in status
### to decode the certs
```
echo "<encoded certs>" | base64 --decode
```
### share this to user
### kube-controller manager had the authority for CSR signing and approval