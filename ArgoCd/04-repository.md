# Repository

## Private Git Repos
- Public repos can be used directly in application.
- Private repos needs to be registered in ArgoCD with proper authentication before using it in applications.
- ArgoCD support connecting to private repos using below ways:
    - HTTPs: using username and password or access token.
    - SSH: using ssh private key.
    - GitHub / GitHub Enterprise : GitHub App credentials.
- Private repos credentials are stored in normal k8s secrets.
- You can register repos using declarative approach, cli and web UI.
### Git Repo using HTTPs
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/argoproj/private-repo
  password: my-password
  username: my-username
```
### Git Repo using HTTPs - insecure
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/argoproj/private-repo
  password: my-password
  username: my-username
  insecure: true
```
### Git Repo using HTTPs and Tls
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/argoproj/private-repo
  password: my-password
  username: my-username
  tlsClientCertData: ….
  tlsClientCertKey: ….
```
### Git Repo using SSH
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/argoproj/private-repo
  sshPrivateKey: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  ...
  -----END OPENSSH PRIVATE KEY-----
```
### Git Repo using GitHub App
```yml
apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/argoproj/private-repo
  githubAppID: 1
  githubAppInstallationID: 2
  githubAppPrivateKey: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  ...
  -----END OPENSSH PRIVATE KEY-----
```
## Add private Git repo to ArgoCD using PAT
1. Create Secret add PAT as password
```
kubectl apply -f 04-manifest-files/secret.yaml
```
2. Create Application for using Private repo created in step 1
```
kubectl apply -f 04-manifest-files/application.yaml
```
## Add private Git repo to ArgoCD using SSH key
1. Generate Private SSH key
```
ssh-keygen -f private-repo
ssh-keygen -t rsa -f github
```
2. Add Public key into Github Repo

3. Create secret
```
kubectl apply -f 04-manifest-files/02-secret.yaml
```
4. Create Application using ssh repo
```
kubectl apply -f 04-manifest-files/02-application.yaml
```

# Helm Repo
- Public standard Helm repos can be used directly in application.
- Non standard Helm repositories have to be registered explicitly.
- Private Helm repos needs to be registered in ArgoCD with proper authentication before using it in applications.
- ArgoCD support connecting to private Helm repos using username/password and tls cert/key.
- Registering Helm repos in ArgoCD can be done declaratively, CLI and Web UI.

### Private Helm Repo declaratively
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

### Private Helm Repo CLI
- Add a private Helm repository named 'stable' via HTTPS 
```yml
argocd repo add https://charts.helm.sh/stable --type helm --name stable --username test --password test
```

### Private Helm Repo Web UI
![alt text](image-1.png)

### Adding Helm repo to argocd
1. Create Secret
```
kubectl apply -f 04-manifest-files/03-secret.yaml
```
2. Create Application for using Private repo created in step 1
```
kubectl apply -f 04-manifest-files/03-application.yaml
```

# Credential Templates
- Used If you want to use the same credentials for multiple repositories in your organization without having to repeat credential configuration.
- Defined as same as repositories credentials information, with different label value argocd.argoproj.io/secret type: repo creds
- In order for ArgoCD to use a credential template for any given repository, the following conditions must be met:
- The URL configured for a credential template (e.g. https://github.com/mabusaa ) must match as prefix for the repository URL e.g. https://github.com/mabusaa/argocd example apps
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

## create credentia templates
1. Delete all repo created before
```
kubectl apply -f 04-manifest-files/04-secret.yaml
```
2. Verify Secret

kubectl -n argocd get secret
kubectl -n argocd describe secret private-repo-creds-https
2. Create Application for using Private repo created in step 1
```
kubectl apply -f 04-manifest-files/04-application.yaml
```