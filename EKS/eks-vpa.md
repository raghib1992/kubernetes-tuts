# VPA
## Do not use vpa in production,as it restart the pod
## deploy vpa with deployment
## command to check how many cpu and memory used by pod
```
kubectl top pod <pod name>
```
### to gete the recomendation from vpa for cpu and memory allocation to pod
```
kubectl describe vpa
```
************************
# GoldiLock
## To install golilock vpa is required
## Ref https://github.com/FairwindsOps/goldilocks
