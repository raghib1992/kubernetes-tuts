# Node Selector
## To set limitation on the pod so it go into the desire node
## pod-definitionfile
pod-definition.yaml
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
    nodeName: node02
    nodeSelector:
        size: Large   # Large label assigned to node
```
# command to label node
```
kubectl label nodes <node-name> <label-key>=<label-value>
```

## Limitation of Node selector, if we asked a pod not to assign on small node or assign on Large or medium
****************************************************

Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=worker-1

