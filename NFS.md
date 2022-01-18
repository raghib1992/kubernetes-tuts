# Create NFS
## create directory
```
sudo mkdir /srv/nfs/kubedata -p
```
```
sudo chown nobody: /srv/nfs/kubedata
sudo systemctl enable nfs-server
sudo systemctl start nfs-server
```
## edit /etc/export
vi /etc/exports
/srv/nfs/kubedata   *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)

sudo exportfs -rav
sudo exports -v

Get ip address of NFS server 

# mount the NFS to any worker node
mount -t nfs  <ip-addr>:/srv/nfs/kubedata /mnt
mount | grep kubedata
unmount /mnt 