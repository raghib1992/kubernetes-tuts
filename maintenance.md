# OS Maintenanace
## drain the pod to other nodes
```
kubectl drain <node-name>
```
## after maintenance, to make node scheduleable
```
kubectl uncordon <node-name>
```
## to make node unscheduleable
```
kubectl cordon <node-name>
```
