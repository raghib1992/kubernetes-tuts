# Install istioctl in WIndow
1. Download ZIp file
https://github.com/istio/istio/releases
2. The istioctl client binary in the bin/ directory.

3. istioctl install --set profile=demo -y


# Install Istio in Linux
1. Download


# Install istio profile
1. istioctl install --set profile=demo -y
2. kubectl get all -n istio-system
3. Mark default naemspace with label istio-injection
```sh
kubectl label namespace default istio-injection=enabled
```
4. Test by installing sample app
```sh
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/bookinfo/platform/kube/bookinfo.yaml

kubectl apply -f ./sample/bookinfo/platform/kube/bookinfo.yaml
```

# Install Kaili Addons
### Kiali.yaml file
```sh
kubectl apply -f samples/addons/kiali.yaml
```
# Port forward kiali
```sh
kubectl -n istio-system port-forward svc/kiali 20001:20001
```