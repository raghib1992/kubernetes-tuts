# Static Pod
## A pod created by kubelet by its own, without the help of the master node
## kubelet.service
```
--pod-manifest-path=/etc/Kubernetes/manifests \\
```
## or provide config path and provide path in the config path
```
config=kubeconfig.yaml \\
```
### kubeconfig.yaml
```
sataticPodPath: /etc/kubernetes/manifests
```
## Commands
```
docker ps
```
# Run the command 
```
ps -aux | grep kubelet
```
## and identify the config file - --config=/var/lib/kubelet/config.yaml. Then check in the config file for staticPodPath.