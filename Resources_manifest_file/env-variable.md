# command and arguments
```
FROM ubuntu
CMD sleep 10
```
```
FROM ubuntu
CMD ["sleep", "10"]
```
## command to make image and deploy container is
```
docker build -t ubuntu-sleeper
docker run ubuntu-sleeper
```
# Image
```
FROM ubuntu
ENTRYPOINT ["sleep"]
```
```
docker build -t ubuntu-sleeper:2
docker run ubuntu-sleeper:2 10
```
```
FROM ubuntu
ENTRYPOINT ["sleep"]
CMD ["5"]
```
```
docker run ubuntu-sleeper 10  
```
## over write entrypoint
```
docker run --entrypoint sleep2.0 ubuntu-sleeper:2 10
```
# pod definition file to pass arguments
## pod-definition.yml
```
apiVersion: v1
kind: Pod
metadata:
    name: myapp-pod
    labels:
        app: web
        env: prod
        tier: front-end
spec:
    containers:
    - name: nginx-container
      image: nginx
      command: ["sleep2.0"]
      args: ["10"]
```


# Environment Variable
## Docker command to pass env variable
```
docker run -e APP_COLOR=pink simple-web-color
```
## pod-definition.yml
```
apiVersion: v1
kind: Pod
metadata:
    name: myapp-pod
    labels:
        app: web
        env: prod
        tier: front-end
spec:
    containers:
    - name: nginx-container
      image: nginx
      ports:
        - containerPort: 8080
      env:
        - name: APP_COLOR
          value: pink
```
## or

```
env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:
```
```
env:
  - name: APP_COLOR
    valueFrom:
      secretKeyRef:
```
## configMap
## command to view config map
```
kubectl view configmaps
kubectl describe configmaps
```
### Create a config map
#### config file
##### app-config
```
APP_COLOR: blue
APP_MODE: prod
```
```
kubectl create configmap \
    <config-name> --from-literal=<key>=<value>
kubectl create configmap \
    <config-name> --from-file=<path-to-file>
```
#### create config map yaml file
##### config-map.yaml
```
apiVersion: v1
kind: ConfigMap
metadata:
    name: app-config
data:
    APP_COLOR:blue
    APP_MODE: prod
```
```
kubectl create -f config-map.yaml
```
### inject them into the pod definition file
```
envFrom:
  - configMapRef:
      name: app-config
```
```
env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: APP_COLOR
```
```
volumes:
- name: app-config-volume
  configMap:
    name: app-config
```