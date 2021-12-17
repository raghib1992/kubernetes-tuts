# multiple scheduler
## You can have your own scheduler
## my-custom-scheduler.service
```
--scheduler-name=my-custom-scheduler
```
## In kubeadm tool->copy the kube-scheduler manifest file and add scheduler name
```
apiVersion: v1
kind: Pod
metadata:
    name: my-custom-scheduler
    namespace: kube-system
spec:
    containers:
    - name: k8s.gcr.io/kube-scheduler-amd64:v1.11.3
      image: kube-scheduler
      command:
        - kube-scheduler
        - --address=127.0.0.1
        - --kubeconfig=/etc/kubernetes/scheduler.conf
        - --leader-elect=true
        - --scheduler-name=my-custom-scheduler
```
## in pods definition file add scheduler name to use new scheduler
## to know which scheduler is used to schedule pod
```
kubectl get events
kubectl logs my-custom-scheduler --name-space=kube-system
```