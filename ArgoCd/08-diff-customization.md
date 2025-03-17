# Diffing Customization
-Argo CD allows you to optionally ignore differences of problematic
resources/manifests.
- Examples when you might need diffing customization:
    - A controller or mutating webhook is altering the resources after it was submitted to
    Kubernetes at runtime in a manner which contradicts Git.
    - A Helm chart is using a template function such as randAlphaNum, which generates
    different data every time helm template is invoked.
    - There is a bug in the manifest, where it contains extra/unknown fields from the actual
    K8s spec.
- Diffing customization can be configured at application level or at a system
level.

### Argo CD allows ignoring differences using below options:
- RFC6902 JSON patches at a specific JSON path (json pointers)
- JQ path expressions.
- Ignore differences from fields owned by specific managers defined in metadata.managedFields.


### Application level  – Json Pointers 
- Will ignore differences between live and desired states during the diff.
- this will ignore differences in spec.replicasfor all deployments for this
application. 
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: kustomize-guestbook
    namespace: argocd
spec:
    destination:
        namespace: guestbook
        server: "https://kubernetes.default.svc"
    project: default
    source:
        path: kustomize-guestbook
        repoURL: "https://github.com/argoproj/argocd-example-apps.git"
        targetRevision: HEAD
ignoreDifferences:
    - group: apps
      kind: Deployment
      jsonPointers:
      - /spec/replicas
```

### Application level  – Json Pointers - for specific resource 
- this will ignore differences in spec.replicasfor deployment with name guestbook . 
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: kustomize-guestbook
    namespace: argocd
spec:
    destination:
        namespace: guestbook
        server: "https://kubernetes.default.svc"
    project: default
    source:
        path: kustomize-guestbook
        repoURL: "https://github.com/argoproj/argocd-example-apps.git"
        targetRevision: HEAD
ignoreDifferences:
    - group: apps
      kind: Deployment
      name: guestbook
      jsonPointers:
      - /spec/replicas
```

### Application level  –– by specific managers 
- will ignore differences from all fields owned by kube-controller-manager for all resources belonging to this application
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: kustomize-guestbook
    namespace: argocd
spec:
    destination:
        namespace: guestbook
        server: "https://kubernetes.default.svc"
    project: default
    source:
        path: kustomize-guestbook
        repoURL: "https://github.com/argoproj/argocd-example-apps.git"
        targetRevision: HEAD
ignoreDifferences:
    - group: *
      kind: *
      managedFieldsManagers:
      - kube-controller-manager
```

### Demo
1. Create Application 
```
kubectl -n argocd apply -f 08-manifest-fles/01-application.yaml

kubectl -n argocd get application
```
2. Modify replicas and see argocd not notice thhe changes
```
argocd-example-apps/guestbook-with-sub-directories/deployment/deployment.yaml
```
### Real Case Demo
1. Create Application 
```
kubectl -n argocd apply -f 08-manifest-fles/02-application.yaml

kubectl -n argocd get application
```
2. Without igonreCust istio update mutationg webhook which not allowing it to go sync
