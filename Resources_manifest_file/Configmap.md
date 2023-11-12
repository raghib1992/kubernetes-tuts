### Configmap yaml file
```yml
apiVersion: v1
kind: ConfigMap
metadata:
    name: demo-configmap
data:
    name: "Raghib"
    surname: "Nadim"
```
### Create configmap
```yml
# Create config map
kubectl apply -f demo-configmap.yamp
kubectl create configmap demo-configmap --from-literal=db_username=admin --from-literal=db_password=admin123

# List of configmap created
kubectl get cm

# Get the details of the cm
kubectl describe cm demo-configmap
```

### Use Configmap in value in pods
```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox
spec:
  replicas: 2
  selector:
    matchLabels:
      app: busybox
  template:
    metadata:
      name: busybox
      labels:
        app: busybox
    spec:
      containers:
        - name: busybox
          image: busybox
          command: ["/bin/sh"]
          args: ["-c", "sleep 600"]
          env:
            - name: CHANNELNAME
              valueFrom:
                configMapKeyRef:
                  name: demo-configmap
                  key: channel.name
            - name: CHANNELOWNER
              valueFrom:
                configMapKeyRef:
                  name: demo-configmap
                  key: channel.owner
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: second
  labels:
    app: second
spec:
  volumes:
    - name: demo
      configMap:
        name: demo-configmap
  containers:
    - name: busybox
      image: busybox
      command: ["/bin/sh"]
      args: ["-c", "sleep 600"]
      volumeMounts:
        - name: demo
          mountPath: /mydata
```
```yml
kubectl create cm mysql-demo-cm --from-file=files/my.cnf
```

```yml
apiVersion: v1
kind: ConfigMap
metadata:
    name: mysql-demo-cm2
data:
  my.cnf: |
    [mysqld]
    pid-file        = /var/run/mysqld/mysqld.pid
    socket          = /var/run/mysqld/mysqld.sock
    port            = 9999
    datadir         = /var/lib/mysql
    default-storage-engine  = InnoDB
    character-set-server    = utf8
    bind-address            = 127.0.0.1
    general_log_file        = /var/log/mysql/mysql.log
    log_error               = /var/log/mysql/error.log
```
```yml
apiVersion: v1
kind: Pod
metadata:
  name: second
  labels:
    app: second
spec:
  volumes:
    - name: demo
      configMap:
        name: mysql-demo-cm
        items:
          key: my.cnf
          path: my.cnf
  containers:
    - name: busybox
      image: busybox
      command: ["/bin/sh"]
      args: ["-c", "sleep 600"]
      volumeMounts:
        - name: demo
          mountPath: /mydata
```