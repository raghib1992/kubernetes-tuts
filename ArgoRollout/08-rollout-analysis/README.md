# Analysis in Argo Rollouts
![alt text](<Screenshot from 2024-05-05 16-20-25.png>)

# Analysis template 
![alt text](<Screenshot from 2024-05-05 16-24-07.png>)

# Analysis for mock metrics
### Create analysis and rollout
```sh
kubectl apply -f 01-mock-analysis-template.yaml
kubectl apply -f 02-webapp-rollout.yaml
```

To get dns of prometheus
```sh
kubectl run -it --rm --restart=Never dns-test --image=busybox:1.28 -- nslookup prometheus-operated.darwin.svc.cluster.local
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      prometheus-operated.darwin.svc.cluster.local
Address 1: 10.244.0.130 prometheus-prometheus-kube-prometheus-prometheus-0.prometheus-operated.darwin.svc.cluster.local
pod "dns-test" deleted
```