## Link *https://blog.stackademic.com/create-various-kubernetes-resources-using-terraform-7fedc0bcf427*

Create various Kubernetes resources using Terraform

Step 1: Set Up Terraform Configuration
Create a Terraform project directory
```sh
mkdir terraform-k8s && cd terraform-k8s
```
Create a provider.tf file to define the Kubernetes provider
```t
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
```
Note: Make sure to update the path of config file


Step 2: Define Kubernetes Resources
Create a namespace.tf file to define a Kubernetes namespace.
resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo-namespace"
  }
}
Create a deployment.tf file for deploying an application.
resource "kubernetes_deployment" "demo" {
  metadata {
    name = "demo-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "demo"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "demo-deployment"
        }
      }
    }
  }
}
Create a service.tf file to expose the deployment.
resource "kubernetes_service" "demo" {
  metadata {
    name = "demo-service"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = "example"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
Create a configmap.tf file to define the config map.
resource "kubernetes_config_map" "demo" {
  metadata {
    name = "demo-config"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  data = {
    "config.json" = jsonencode({
      "key" = "value"
    })
  }
}
Create a secret.tf file to define a Kubernetes Secret.
resource "kubernetes_secret" "demo" {
  metadata {
    name = "demo-secret"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  data = {
    "password" = base64encode("supersecret")
  }
}
Note: It is not good practice to use the Kubernetes native secrets instead use external secrets or secret store csi driver

Create a pvc.tf file to define a PersistentVolumeClaim.
resource "kubernetes_persistent_volume_claim" "demo" {
  metadata {
    name = "demo-pvc"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}
Now, let’s modify the deployment to mount the ConfigMap and Secret.
resource "kubernetes_deployment" "demo" {
  metadata {
    name = "demo-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "demo"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "demo"

          volume_mount {
            mount_path = "/etc/config"
            name       = "config"
          }

          volume_mount {
            mount_path = "/etc/secret"
            name       = "secret"
            read_only  = true
          }
        }

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.example.metadata[0].name
          }
        }

        volume {
          name = "secret"
          secret {
            secret_name = kubernetes_secret.example.metadata[0].name
          }
        }
      }
    }
  }
}



Step 3: Initialize the working directory
Run terraform init command in the working directory. It will download all the necessary providers, and all the modules & also initialize the backend as well.

Step 4: Create a Terraform plan
Run terraform plan command in the working directory. It will give the execution plan.

Step 5: Run Terraform apply
Run terraform apply command in the working directory and it will create all the required resources on AWS.