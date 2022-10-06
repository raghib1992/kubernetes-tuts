Configmap yaml file
```
apiVersion: v1
kind: ConfigMap
metadata:
    name: demo-configmap
data:
    name: "Raghib"
    surname: "Nadim"
```
Create configmap
kubectl apply -f demo-configmap.yamp

kubectl get cm

kubectl describe cm demo-configmap

Create configmap
kubectl create configmap demo-configmap --from-literal=db_username=admin --from-literal=db_password=admin123

Use COnfigmap in value in pods
```
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

```
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

kubectl create cm mysql-demo-cm --from-file=files/my.cnf

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