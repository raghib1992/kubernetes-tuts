
# Private Git Repos
- Public repos can be used directly in application.
- Private repos needs to be registered in ArgoCD with proper authentication before using it in applications.
- ArgoCD support connecting to private repos using below ways:
    - HTTPs: using username and password or access token.
    - SSH: using ssh private key.
    - GitHub / GitHub Enterprise : GitHub App credentials.
- Private repos credentials are stored in normal k8s secrets.
- You can register repos using declarative approach, cli and web UI.
## Create the secret using kubectl
```
kubectl apply -f 04-manifest-files/
```
## Verify secret is created
```
kubectl get secret private-repo-ssh -n argocd
```

## Git Repo using HTTPs
#### Note: To define a repo using declarative approach you have to add a label of  "argocd.argoproj.io/secret-type: repository"
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-https
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: "https://github.com/raghib1992/argocd-private-repo.git"
  password: github_pat_11APVOECY0xUi0zrkSjQGn
  username: my-token
```
## Git Repo using HTTPs insecure
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-https
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: "https://github.com/raghib1992/argocd-private-repo.git"
  password: github_pat_11APVOECY0xUi0zrkSjQGn
  username: my-token
  insecure: true
```

## Git Repo using HTTPs and Tls
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-https
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: "https://github.com/raghib1992/argocd-private-repo.git"
  password: github_pat_11APVOECY0xUi0zrkSjQGn
  username: my-token
  tlsClientCertData: ....
  tlsClientCertKey: ...
```

## Generate ssh key
```
ssh-keygen -t rsa -f github
```
## Git Repo using GitHub App
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-ssh
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: "https://github.com/raghib1992/argocd-private-repo.git"
  sshPrivateKey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
    NhAAAAAwEAAQAAAYEAwEgLO4Zd3jltUj7I21a/VBM8yRSpTQcZW+7Rjz6Ub6oKMwT8WVpx
    yt5RB5GjbeOecx9VI3h9Nu837wPqAVwW4wjLR48JHiWr7543AUrLdHvMZaYmVloJAGRurv
    -----END OPENSSH PRIVATE KEY----
```

# Helm Repo
- Public standard Helm repos can be used directly in application.
- Non standard Helm repositories have to be registered explicitly.
- Private Helm repos needs to be registered in ArgoCD with proper authentication before using it in applications.
- ArgoCD support connecting to private Helm repos using username/password and tls cert/key.
- Registering Helm repos in ArgoCD can be done declaratively, CLI and Web UI.

## Private Helm Repo declaratively
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-https
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: helm
  name: argo
  url: "https://argoproj.github.io/argo-helm"
  password: my-password
  username: my-username
  tlsClientCertData: ....
  tlsClientCertKey: ...
```

## Private Helm Repo CLI
- Add a private Helm repository named 'stable' via HTTPS 
```yml
argocd repo add https://charts.helm.sh/stable --type helm --name stable --username test --password test
```

## Private Helm Repo Web UI
![alt text](image-1.png)


# Credential Templates
- Used If you want to use the same credentials for multiple repositories in your organization without having to repeat credential configuration.
- Defined as same as repositories credentials information, with different label value argocd.argoproj.io/secret type: repo creds
- In order for ArgoCD to use a credential template for any given repository, the following conditions must be met:
- The URL configured for a credential template (e.g. https://github.com/mabusaa ) must match as prefix for the repository URL (e.g. https://github.com/mabusaa/argocd example apps
- The repository must either not be configured at all, or if configured, must not contain any credential information.
- Registering credentials in ArgoCD can be done declaratively , CLI and Web UI.

## Credential Templates declaratively
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-https
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: "https://github.com/raghib1992/argocd-private-repo.git"
  password: github_pat_11APVOECY0xUi0zrkSjQGn
  username: my-token
```

## Credential Templates CLI
- Add credentials with user/pass authentication to use for all repositories under *https://git.example.com/repos*
```sh
argocd repocreds add https://git.example.com/repos/ --username git --password secret
```

## Credential Templates Web UI
![alt text](image-2.png)