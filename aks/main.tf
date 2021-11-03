terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.46.0"
    }
  }  
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate20023"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

variable "resource_group_name" {
}

variable "location" {
}

variable "cluster_name" {
}

variable "dns_prefix" {
}

variable "ssh_public_key" {
}

variable "node_count" {
  type = number
  default = 1
}

resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file("${var.ssh_public_key}")
    }
  }

  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = "Standard_B2s"  
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }  

  tags = {
    Environment = "Dev"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}

output "host" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
}