# Node Selector

## to check label detials 
```
kubectl get nodes -o wide --show-labels
```
## To set limitation on the pod so it go into the desire node
## Command to label node
```
kubectl label node <node-name> <label-key>=<label-value>
```
## to remove the label
```
kubectl label node <node name> <key>-
```
## check the label of nodes
```
kubectl get node <node name> --show-labels
kubectl get nodes -l <key>=<value >
```
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
## Limitation of Node selector, if we asked a pod not to assign on small node or assign on Large or medium
****************************************************

Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=worker-1

****************************************************
## Select node as per namespace


label the node

Update kubeapi
In master node
```
cd /etc/kubernetes/manifests
```
edit kube-apiserver.yaml
```
edit --enable-admission-plugins=NodeRestriction,PodNodeSelector
```
## Configuration Annotation Format
### PodNodeSelector uses the annotation key scheduler.alpha.kubernetes.io/node-selector to assign node selectors to namespaces.
```
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    scheduler.alpha.kubernetes.io/node-selector: "
    name-of-node-selector
  name: namespace3
```