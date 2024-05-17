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