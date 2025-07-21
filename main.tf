terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}

# Simulate AWS EKS cluster configuration
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "bridgephase-cluster"
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type for nodes"
  type        = string
  default     = "t3.medium"
}

# Simulate cluster configuration file
resource "local_file" "cluster_config" {
  content = templatefile("${path.module}/cluster-template.yaml", {
    cluster_name   = var.cluster_name
    node_count     = var.node_count
    instance_type  = var.instance_type
  })
  filename = "${path.module}/generated-cluster-config.yaml"
}

# Simulate node group scaling
resource "local_file" "node_scaling_config" {
  content = jsonencode({
    cluster_name = var.cluster_name
    node_groups = {
      primary = {
        desired_capacity = var.node_count
        max_size        = var.node_count * 2
        min_size        = 1
        instance_types  = [var.instance_type]
      }
    }
  })
  filename = "${path.module}/node-scaling.json"
}

output "cluster_name" {
  value = var.cluster_name
}

output "node_count" {
  value = var.node_count
}
