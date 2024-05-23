variable "kube_config_path" {
  type = string
  default = "~/.kube/config"
}

variable "cluster_vm_ssh_authorized_key" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "k8s-at-kubevirt"
}
variable "cluster_namespace" {
  type = string
  default = "default"
}

variable "master_pool_size" {
  type = number
  default = 1
  description = "amount of master nodes in cluster"
}

variable "worker_pool_size" {
  type = number
  default = 2
  description = "amount of worker nodes in cluster"
}

variable "cluster_node_os_image_type" {
  type = string
  # default = "http"
  default = "registry"
  description = "type of the cloudinitimage source (http or registry)"
}

variable "cluster_node_os_image_url" {
  type = string
  # default = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  default = "docker://ghcr.io/alirionx/kubevirt-noble-x64"
  description = "Examples: http => https://cloud-images... registry => docker://ghcr.io/..."
}

variable "master_node_disk_size" {
  type = number
  default = 16
  description = "size of nodes OS disk in Gigabyte"
}
variable "worker_node_disk_size" {
  type = number
  default = 24
  description = "size of nodes OS disk in Gigabyte"
}

variable "master_vm_sockets" {
  type = number
  default = 1
  description = "CPU sockets for master nodes"
}
variable "master_vm_cores" {
  type = number
  default = 2
  description = "CPU cores per socket for master nodes"
}
variable "master_vm_memory" {
  type = number
  default = 2048
  description = "memory size for master nodes in Megabyte"
}

variable "worker_vm_sockets" {
  type = number
  default = 2
  description = "CPU sockets for worker nodes"
}
variable "worker_vm_cores" {
  type = number
  default = 2
  description = "CPU cores per socket for worker nodes"
}
variable "worker_vm_memory" {
  type = number
  default = 4096
  description = "memory size for worker nodes in Megabyte"
}