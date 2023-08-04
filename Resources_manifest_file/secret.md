# configure secret
## command to view secret
```
kubectl get secrets
kubectl describe secrets
kubectl get secret <secret-name> -o yaml
```
## create the secret
### mysecret
```
DB_HOST: mysql
DB_USER: root
DB_PASSWORD: passwrd
```
### command to create secret
```
kubectl create secret generic \
    <secret-name> --from-literal=<key>=<value>
kubectl create secret generic \
    <secret-name> --from-file=<path to file>
```
### secret.yaml
```
apiVersion: v1
kind: Secret
metadata:
    name: app-secret
data:
    DB_HOST: mysql
    DB_USER: root
    DB_PASSWORD: passwrd
```
```
kubectl create -f secret.yaml
```
#### convert plain text to encoded form to use in the secret yaml file
```
echo -n 'passwrd' | base64
```
#### convert the encoded into plain text
```
echo -n '<coded value> | base64 --decode
```
## Injected into pod
### pods yaml file
### pod-definition.yml
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
      command:
      - sleep
      - "1000"
      envFrom:
      - secretRef:
          name: app-secret
```
```
env:
  - name: DB_Password
    valueFrom:
      secretKeyRef:
        name: app-secret
        key: DB_PASSWORD
```
```
volumes:
- name: app-secret-volume
  secret:
    secretName: app-secret
```
#### when you mount secret as a pod, each value mount as file
```
ls /opt/app-secret-volume/DB_Password
```
