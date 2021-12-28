# Storage
# Storage Drivers
## Docker store data on local file system
docker store data on 
```
/var/lib/docker/aufs,container,image,volume
```
# Volume Drivers
## local(default)
### save data on aws cloud
```
docker run -ti \
    --name mysql \
    --volume-driver rexray/ebs \
    --mount src=ebs-vol,target=/var/lib/mysql mysql
```
*********************
# Storage Class
## static Provisioning
## Dymanic Provisioning
### we dont nedd pv once we create storage class
sc-definition.yaml
```
apiVersion: storage.k8s.io/v1
kind:StorageClass
metadata:
    name: google-storage
provisioner: kubernetes.io/gce-pd
parameters:
 type: pd-standard, pd-ssd
 replication-type: none,regional-pd 
```
### now in pvc definition mention the sc
pvc-definition.yaml
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: myclaim
spec:
    accessModes:
        - ReadWriteOnce
    storageClassName: <sc-name>
    resources:
        requests:
            storage: 500Mi
```
