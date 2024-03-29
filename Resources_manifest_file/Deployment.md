# Deployment
## upgrading capabilities
## dep-def.yml
```yml
apiVersion: apps/v1
kind: Deployment
metadata:
    namespace: finance
    name: john-deployment
    labels:
      app: busybox
spec:
    template:
        metadata:
            name: myapp-pod
            labels:
              app: busybox
        spec:
            containers:
                - name: busybox
                  image: busybox
                  command: ["/bin/sh", "-ec", "while :; do echo '.';sleep 5 ; done" ]
    replicas: 2
    selector:
        matchLabels:
          app: busybox
```
### command to run deployment
```sh
kubectl create -f deploy-def.yml
kubectl get deployments
kubectl get all
kubectl create deployment --image=nginx nginx
kubectl expose deployment <name> --port 80
kubectl scale deployment <name> --replicas=5
kubectl edit -f <definition file>
# Edit the local def file and run this command
kubectl replace -f <definition file> 
kubectl delete -f <definition file>
kubectl set image deployment <name> oldImage=newImage
kubectl apply -f <definition-file>
```
### Generate Deployment YAML file (-o yaml). Don't create it(--dry-run) with 4 Replicas (--replicas=4)
```sh
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml
```
### In k8s version 1.19+, we can specify the --replicas option to create a deployment with 4 replicas.
```
kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml
```
### --dry-run: By default as soon as the command is run, the resource will be created. If you simply want to test your command , use the --dry-run=client option. This will not create the resource, instead, tell you whether the resource can be created and if your command is right.

### -o yaml: This will output the resource definition in YAML format on screen.

