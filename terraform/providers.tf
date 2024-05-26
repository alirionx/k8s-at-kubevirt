provider "kubernetes" {
  config_path    = var.kube_config_path
  config_context = "default"
  # host = "https://192.168.10.131:6443"
  # token = "ey..."
  # insecure = true
}