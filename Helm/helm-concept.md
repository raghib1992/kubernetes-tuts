## chart.yaml
#### Contain all meta data
## values.yaml
#### default configuration
## templates
#### contain all template to deploy pod, service etc

values.yaml
```
name: app
containers:
    name: nginx
    image: nginx
    port: 80
```
pod.yaml
```
apiVersion: v1
kind: Pod
metadata:
    name: {{ .values.name }}
spec:
    containers:
        name: {{ .values.containers.name }}
        image: {{ .values.containers.image }}
        ports:
        - containerPort: {{ .values.containers.port }}
```
## my-values.yaml
```
containers:
    port: 8080
```

## can provide values which over written the values.yaml file
helm install --values=my-values.yaml <chart name>
helm install --set containers.port=8090 <chart name>