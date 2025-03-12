# Tracking Strategies

### Tracking Strategies
- ArgoCD provides several options to track manifests (sources) whether its in Git repos or Helm repos.
    - Git repos tracking :
    - Commit SHA (good for production).
    - Tags (good for production).
    - Branch tracking (ex: main branch).
    - Symbolic reference (HEAD).
- Helm repos tracking : Helm always use semantic versioning
    - Specific version v1.2
    - Range 1.2.* or >=1.2.0 <1.3.0.
    - Latest * or >=0.0.0

### Git – using tag
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: example
    namespace: argocd
spec:
    destination:
        namespace: default
        server: "https://kubernetes.default.svc"
    project: default
    source:
        path: guestbook
        repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
        targetRevision: v1
```

### Git – commit SHA
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: example
    namespace: argocd
spec:
    destination:
        namespace: default
        server: "https://kubernetes.default.svc"
    project: default
    source:
        path: guestbook
        repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
        targetRevision: 2455bb6
```

### Git – branch
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: example
    namespace: argocd
spec:
    destination:
        namespace: default
        server: "https://kubernetes.default.svc"
    project: default
    source:
        path: guestbook
        repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
        targetRevision: main
```

### Git – symbolic reference
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: example
    namespace: argocd
spec:
    destination:
        namespace: default
        server: "https://kubernetes.default.svc"
    project: default
    source:
        path: guestbook
        repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
        targetRevision: HEAD
```

### Helm – Specific version
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: guestbook
    namespace: argocd
spec:
    destination:
        namespace: guestbook
        server: "https://kubernetes.default.svc"
    project: default
    source:
        chart: sealed-secret
        repoURL: "https://bitnami-labs.github.io/sealed-secrets"
        targetRevision: 1.16.1
```

### Helm – Range
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: guestbook
    namespace: argocd
spec:
    destination:
        namespace: guestbook
        server: "https://kubernetes.default.svc"
    project: default
    source:
        chart: sealed-secret
        repoURL: "https://bitnami-labs.github.io/sealed-secrets"
        targetRevision: '>=3.0.0 <4.1.0' # recent version that is smaller than 4.1.0
```

### Helm – Latest version
```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
    name: guestbook
    namespace: argocd
spec:
    destination:
        namespace: guestbook
        server: "https://kubernetes.default.svc"
    project: default
    source:
        chart: sealed-secret
        repoURL: "https://bitnami-labs.github.io/sealed-secrets"
        targetRevision: * # latest version
```