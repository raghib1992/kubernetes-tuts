https://aws.amazon.com/premiumsupport/knowledge-center/efs-mount-automount-unmount-steps/

https://aws.amazon.com/getting-started/hands-on/create-mount-amazon-efs-file-system-on-amazon-ec2-using-launch-wizard/

## NFS Mount
```
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-00433efb31ab331bf.efs.ap-south-1.amazonaws.com:/ efs-mount-point/
```