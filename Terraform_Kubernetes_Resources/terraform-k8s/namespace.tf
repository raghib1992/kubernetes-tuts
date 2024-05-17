resource "kubernetes_namespace" "example" {
  metadata {
    name = "demo-namespace"
  }
}