# Resource Configuration
## Use declarartive way
## backing up all
```
kubectl get all --all-namespaces -o yaml > all-deploy-service.yaml
```

# ETCD
## in ETCD service congiguration a dir is provided where all the data where saved
```
--data-dir=/var/lib/etcd
```
## also take the snapshot of the etcd
```
ETCDCTL_API=3 etcdctl \
snapshot save snapshot.db
```
### view the status of the snapshot
```
ETCDCTL_API=3 etcdctl \
snapshot status snapshot.db
```
### to restore the snapshot
```
service kube-apiserver stop
ETCDCTL_API=3 etcdctl \
snapshot restore snapshot.db \
--data-dir /var/lib/etcd-from-backup
```
#### then configure ETCD service congiguration a dir is provided where all the data where saved
```
--data-dir=/var/lib/etcd-from-backup
```
#### reload the service daemon
```
systemctl daemon-reload
service etcd restart 
service kube-apisercer start
```
# note always mention:
```
ETCDCTL_API=3 etcdctl \
snapshot save snapshot.db \
--endpoints=https://127.0.0.1:2379 \
--cacert=/etc/etcd/ca.crt \
--cert=/etc/etcd/etcd-server.crt \
--key=/etc/etcd/etcd-server.key
```

