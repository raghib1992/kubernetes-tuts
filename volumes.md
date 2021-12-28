
# Volumes
## volume and mount
definition.yaml
```
apiVersion: v1
kind: Pod
metadata:
    name: random-number-generator
spec:
    containers:
    - image: alpine
      name: alpine
      command: ["/bin/sh","-c"]
      args: ["shuf -i 0-100 -n 1 >> /opt/number.out;"]
      volumeMounts:
        - mountPath: /opt
        name: data-volume
    volumes:
    - name: data-volume
      hostPath:
        path: /data
        type: Directory
```
## volumes in aws ebs
```
volumes:
- name: data-volume
  awsElacticBlockStore:
    volumeID: <volumeID>
    fsType: ext4
```
******************************************
# Persistence Volume
## persistence-volume definition file
### pv-definition.yaml
```
apiVersion: v1
kind: PersistentVolume
metadata:
    name: pv-vol1
spec: 
    accessModes:
        - ReadWriteOnce   #ReadOnlyMany,ReadWriteOnce,ReadWriteMany
    capacity:
        storage: 1Gi
    hostPath:
        path: /tmp/data
```
```
kubectl create –f pv-definition.yaml
kubectl get persistentvolume
```
### replace host path, when you volumes on cloud
```
awsElacticBlockStore:
    volumeID: <volumeID>
    fsType: ext4
```
******************
# Persistence Volume Claim
## PVC definition file
### pvc-definition.yaml
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: myclaim
spec:
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
            storage: 500Mi
```
```
kubectl create -f pvc-definition.yaml
kubectl get pvc
```
### delete pvc
```
kubectl delte persistencevolumeclaim <name>
```
#### what happen delete
#### by default it retain untill manually deleted
```
persistentVolumeReclaimPolicy: Retain, Delete,Recycle
```

## also PVC in pod definition, deployment
### pod-definition.yaml
```
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```
Ref: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes

************************************
