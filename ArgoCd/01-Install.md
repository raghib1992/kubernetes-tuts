## **Installation**

1. **Non-HA**:
- **Create argocd namespace**
```
kubectl create ns argocd
kubectl get ns
```
- **Install ArgoCD**
```sh
# cluster-admin privileges:
kubectl apply -f  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -n argocd

# namespace level privileges: 
kubectl apply -f https://github.com/argoproj/argo-cd/raw/stable/manifests/namespace-install.yaml -n argocd

# Verify pods and secret running in argocd ns
kubectl get po -n argocd
kubectl get secret -n argocd
```
- **Check pods which should be created**
```sh
kubectl -n argocd get po

# output should be
argocd-application-controller-0                    1/1     Running   0          93s
argocd-applicationset-controller-df44d7f64-7fb4q   1/1     Running   0          94s
argocd-dex-server-554bd5ccd6-nhgz7                 1/1     Running   0          94s
argocd-notifications-controller-64d548cb97-hsh2b   1/1     Running   0          94s
argocd-redis-7b6b8b44bf-btchq                      1/1     Running   0          94s
argocd-repo-server-89cb644f7-lttxv                 1/1     Running   0          94s
argocd-server-7d979949f8-fvxdt                     1/1     Running   0          93s
```

- **Initial admin password is stored as a secret in argocd namespace**
```sh
# Method 1
# Get Password using argocd cli
argocd admin initial-password -n argocd

# Mwthod 2
# check list of secret installed in argocd namespace
kubectl -n argocd get secret

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# for linux to convert base64 to string
echo Zf5T6Hnml9hUql9T | base64 --decode

# for window to convert base64 to string
[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String("emFmNTZhRkVYeVRUNXFXeA=="))
# username: admin
# password: 
```
- **Access argocd**
    - Expose by using:
        - Service : `LoadBalancer`
            - Change the argocd server service type to LoadBalancer
        - Ingress: Use your preferred `ingress` controller
            - Create an ingress resource that point into argocd server service.
        - Port-forward: simply you can use this to access locally on your machine
            ```sh
            kubectl port-forward svc/argocd-server -n argocd 8080:443

            # open browser *https://localhost:8080/*
            ```
- **Install ArgoCD cli**
    - Install Argo CD CLI on your machine
    - Follow official docs for your preferred platform (linux or mac or windows): *https://argo-cd.readthedocs.io/en/stable/cli_installation/*
    - Expose Argo CD Server whether using port forward or ingress or load balancer service
    - Use CLI to login to Argo CD using admin user and password
    - Verify that you can get data from Argo CD by running a any command such as argocd cluster list.
- **Installing on window**
```powershell

# You can view the latest version of Argo CD at the link above or run the following command to grab the version:
$version = (Invoke-RestMethod https://api.github.com/repos/argoproj/argo-cd/releases/latest).tag_name

# Replace $version in the command below with the version of Argo CD you would like to download:
$url = "https://github.com/argoproj/argo-cd/releases/download/" + $version + "/argocd-windows-amd64.exe"
$output = "argocd.exe"

Invoke-WebRequest -Uri $url -OutFile $output

#Also please note you will probably need to move the file into your PATH. Use following command to add Argo CD into environment variables PATH
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Path\To\ArgoCD-CLI", "User")

#After finishing the instructions above, you should now be able to run argocd commands.
```

- **Install on Linux**
```sh
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

- **Configure cli**
```sh
# Check version
argocd version

# Login
argocd login localhost:8080
```


2. HA:

a. cluster-admin privileges: https://github.com/argoproj/argo-cd/raw/stable/manifests/ha/install.yaml

b. namespace level privileges: https://github.com/argoproj/argo-cd/raw/stable/manifests/ha/namespace-install.yaml

3. Light installation "Core"

https://github.com/argoproj/argo-cd/raw/stable/manifests/core-install.yaml

4. Helm chart: https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd


### Medium Link to create rollout and cd
- *https://victoryeo-62924.medium.com/getting-started-with-argo-cd-and-argo-rollout-757fc37ea8e8#:~:text=Argo%20CD%20monitors%20the%20changes,canary%2C%20blue%2Fgreen).*
