resource "kubernetes_config_map" "example" {
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