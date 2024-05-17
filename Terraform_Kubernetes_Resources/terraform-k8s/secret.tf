resource "kubernetes_secret" "example" {
  metadata {
    name = "demo-secret"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  data = {
    "password" = base64encode("supersecret")
  }
}