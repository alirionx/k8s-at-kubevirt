# --------------------------------------------------------------------
### Useful Outputs for kubeone ### 

data "kubernetes_resources" "masters_machine_services" {
  depends_on = [kubernetes_manifest.masters_machine_services]
  count = var.master_pool_size
  api_version    = "v1"
  kind           = "Service"
  namespace      = var.cluster_namespace 
  field_selector = "metadata.name=master-${var.cluster_name}-${count.index}"
}
data "kubernetes_resources" "workers_machine_services" {
  depends_on = [kubernetes_manifest.workers_machine_services]
  count = var.worker_pool_size
  api_version    = "v1"
  kind           = "Service"
  namespace      = var.cluster_namespace 
  field_selector = "metadata.name=worker-${var.cluster_name}-${count.index}"
}

data "kubernetes_resources" "masters_machine_pods" {
  depends_on = [kubernetes_manifest.masters_machine_pool]
  count = var.master_pool_size
  api_version    = "v1"
  kind           = "Pod"
  namespace      = var.cluster_namespace 
  label_selector = "vm.kubevirt.io/name=master-${var.cluster_name}-${count.index}"
}
data "kubernetes_resources" "workers_machine_pods" {
  depends_on = [kubernetes_manifest.workers_machine_pool]
  count = var.worker_pool_size
  api_version    = "v1"
  kind           = "Pod"
  namespace      = var.cluster_namespace 
  label_selector = "vm.kubevirt.io/name=worker-${var.cluster_name}-${count.index}"
}


output "node_ips" {
  depends_on = [
    data.kubernetes_resources.masters_machine_services,
    data.kubernetes_resources.workers_machine_services,
    data.kubernetes_resources.masters_machine_pods,
    data.kubernetes_resources.workers_machine_pods
  ]

  value = { 
    masters_public_ips = data.kubernetes_resources.masters_machine_services[*].objects[0].status.loadBalancer.ingress[0].ip
    masters_private_ips = data.kubernetes_resources.masters_machine_pods[*].objects[0].status.podIP
    workers_public_ips = data.kubernetes_resources.workers_machine_services[*].objects[0].status.loadBalancer.ingress[0].ip
    workers_private_ips = data.kubernetes_resources.workers_machine_pods[*].objects[0].status.podIP
  }
}


resource "local_file" "kubeone_manifest" {
  depends_on = [
    data.kubernetes_resources.masters_machine_services,
    data.kubernetes_resources.workers_machine_services,
    data.kubernetes_resources.masters_machine_pods,
    data.kubernetes_resources.workers_machine_pods
  ]

  content = templatefile( "./templates/kubeone-manifest.yaml", {
    cluster_name = var.cluster_name
    masters_public_ips = data.kubernetes_resources.masters_machine_services[*].objects[0].status.loadBalancer.ingress[0].ip
    masters_private_ips = data.kubernetes_resources.masters_machine_pods[*].objects[0].status.podIP
    workers_public_ips = data.kubernetes_resources.workers_machine_services[*].objects[0].status.loadBalancer.ingress[0].ip
    workers_private_ips = data.kubernetes_resources.workers_machine_pods[*].objects[0].status.podIP
  })
  filename = "../kubeone/cluster-${var.cluster_name}.yaml"
}