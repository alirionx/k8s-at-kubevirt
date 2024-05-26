
# --------------------------------------------------------------------
### The Masters Pool ### 
data "template_file" "masters_machine_pool" {
  template = "${file("./templates/machine-pool.yaml")}"
  vars = {
    node_type = "master"
    cluster_name = var.cluster_name
    cluster_namespace = var.cluster_namespace
    cluster_vm_ssh_authorized_key = var.cluster_vm_ssh_authorized_key
    pool_size = var.master_pool_size
    cluster_node_os_image_type = var.cluster_node_os_image_type
    cluster_node_os_image_url = var.cluster_node_os_image_url
    node_disk_size = var.master_node_disk_size
    vm_sockets = var.master_vm_sockets
    vm_cores = var.master_vm_cores
    vm_memory = var.master_vm_memory
  }
}

resource "kubernetes_manifest" "masters_machine_pool" {
    manifest =  yamldecode("${data.template_file.masters_machine_pool.rendered}")
    computed_fields = [
      "metadata.annotations",
      "metadata.labels",
      "spec.virtualMachineTemplate.metadata.creationTimestamp",
      "spec.virtualMachineTemplate.spec.dataVolumeTemplates[0].creationTimestamp",
      "spec.virtualMachineTemplate.spec.template.metadata.creationTimestamp",
    ]
    wait {
      fields = {
        "status.readyReplicas" = var.master_pool_size
      }
    }
    timeouts {
      create = "10m"
      update = "10m"
      delete = "1m"
    }
}

# ----------------------
### The Workers Pool ### 

data "template_file" "workers_machine_pool" {
  template = "${file("./templates/machine-pool.yaml")}"
  vars = {
    node_type = "worker"
    cluster_name = var.cluster_name
    cluster_namespace = var.cluster_namespace
    cluster_vm_ssh_authorized_key = var.cluster_vm_ssh_authorized_key
    pool_size = var.worker_pool_size
    cluster_node_os_image_type = var.cluster_node_os_image_type
    cluster_node_os_image_url = var.cluster_node_os_image_url
    node_disk_size = var.worker_node_disk_size
    vm_sockets = var.worker_vm_sockets
    vm_cores = var.worker_vm_cores
    vm_memory = var.worker_vm_memory
  }
}

resource "kubernetes_manifest" "workers_machine_pool" {
  count = var.worker_pool_size
  manifest =  yamldecode("${data.template_file.workers_machine_pool.rendered}")
  computed_fields = [
    "metadata.annotations",
    "metadata.labels",
    "spec.virtualMachineTemplate.metadata.creationTimestamp",
    "spec.virtualMachineTemplate.spec.dataVolumeTemplates[0].creationTimestamp",
    "spec.virtualMachineTemplate.spec.template.metadata.creationTimestamp",
  ]
  wait {
    fields = {
      "status.readyReplicas" = var.worker_pool_size
    }
  }
  timeouts {
    create = "10m"
    update = "10m"
    delete = "1m"
  }
}


# --------------------------------------------------------------------
### The Maters Services ### 
data "template_file" "masters_machine_services" {
  count = var.master_pool_size
  template = "${file("./templates/masters-machine-services.yaml")}"
  vars = {
    pool_index = count.index
    cluster_name = var.cluster_name
    cluster_namespace = var.cluster_namespace
  }
}

resource "kubernetes_manifest" "masters_machine_services" {
  count = var.master_pool_size
  manifest =  yamldecode("${data.template_file.masters_machine_services[count.index].rendered}")
}

# ----------------------
### The Workers Services ### 
data "template_file" "workers_machine_services" {
  count = var.worker_pool_size
  template = "${file("./templates/workers-machine-services.yaml")}"
  vars = {
    pool_index = count.index
    cluster_name = var.cluster_name
    cluster_namespace = var.cluster_namespace
  }
}

resource "kubernetes_manifest" "workers_machine_services" {
  count = var.worker_pool_size
  manifest =  yamldecode("${data.template_file.workers_machine_services[count.index].rendered}")
}



# --------------------------------------------------------------------
### Testing Area ###
# output "deschd" {
#   value = "${data.template_file.masters_machine_services[0].rendered}"
# }

# resource "local_file" "test_k8s-res" {
#   content = yamlencode(resource.kubernetes_manifest.workers_machine_services[0])
#   filename = "test.yaml"
# }