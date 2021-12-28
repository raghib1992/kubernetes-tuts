# Install kerberos
## install 
```
yum install krb5-server
```
## Edit /etc/krb5.conf
## Edit /var/kerberos/krb5kdc/kdc.conf
## Edit /var/kerberos/krb5kdc/kadm5.acl
## Create kerberos db
```
kdb5_util create -s -r <Domain Name>
```
### pass Password
### run service
```
systemctl enable kadmin
systemctl enable krb5kdc
systemctl start kadmin
systemctl start krd5fdc
systemctl status kadmin
systemctl status krd5kdc
```

```
firewall-cmd --get-services | grep kerberos --color
firewall-cmd --permanent --add-service kerberos
firewall-cmd --reload
```

```
kadmin.local
```
### add principal
```
addprinc root/admin
```
## create host principal
```
addprinc -randkey host/<hostname.dns>
```
## ket tab for host machine
```
ktadd -k /tmp/file.keytab host/<hostname.dns>
```
#### copy this to other host machine

```
listprincs
```


```
quit
```

## run command in host machine
```
yum install pam_krb5 krb5-workstation
```