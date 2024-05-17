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