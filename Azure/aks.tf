# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  # Private cluster configuration
  private_cluster_enabled = true

  # Default node pool
  default_node_pool {
    name                = var.default_pool_name
    vm_size             = var.default_vm_size
    node_count          = var.default_initial_nodes
    enable_auto_scaling = true
    min_count           = var.default_min_count
    max_count           = var.default_max_count
    os_disk_size_gb     = var.default_disk_size
    vnet_subnet_id      = var.vnet_subnet_id

    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "dev"
      "nodepoolos"    = "linux"
    }

    tags = local.tags
  }

  # Identity configuration
  identity {
    type = "SystemAssigned"
  }

  # Network configuration
  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    load_balancer_sku = "standard"
  }

  # Enable various addons
  azure_policy_enabled             = true
  http_application_routing_enabled = false

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  # Azure AD integration
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = []
    azure_rbac_enabled     = true
  }



  tags = local.tags
}

# GPU Node Pool (Spot instances enabled)
resource "azurerm_kubernetes_cluster_node_pool" "gpu" {
  count                 = var.gpu_vm_size != "" ? 1 : 0
  name                  = var.gpu_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.gpu_vm_size
  node_count            = var.gpu_initial_nodes
  os_disk_size_gb       = var.gpu_disk_size
  vnet_subnet_id        = var.vnet_subnet_id

  # Regular priority for GPU pool (due to quota limits)
  priority        = "Regular"

  node_labels = {
    "nodepool-type" = "gpu"
    "environment"   = "dev"
    "nodepoolos"    = "linux"
  }

  node_taints = [
    "nvidia.com/gpu=present:NoSchedule"
  ]

  tags = local.tags
}

# Log Analytics Workspace for monitoring
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.cluster_name}-logs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.tags
}

# Role assignment for AKS to manage network resources
resource "azurerm_role_assignment" "aks_network_contributor" {
  count                = var.vnet_subnet_id != null ? 1 : 0
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

