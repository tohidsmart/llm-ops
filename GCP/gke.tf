# GKE Cluster
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 34.0"

  project_id         = var.project_id
  name               = var.cluster_name
  region             = var.region
  zones              = [var.zone]
  kubernetes_version = var.cluster_version
  release_channel    = var.release_channel

  # Network configuration
  network           = "default"
  subnetwork        = "default"
  ip_range_pods     = ""
  ip_range_services = ""

  # Cluster features
  enable_private_nodes       = true
  enable_private_endpoint    = false
  master_authorized_networks = []

  # Security
  enable_shielded_nodes = true
  network_policy        = false

  # Workload Identity
  identity_namespace = "${var.project_id}.svc.id.goog"

  # Remove default node pool
  remove_default_node_pool = true

  # Addons
  horizontal_pod_autoscaling = true
  http_load_balancing        = true
  gce_pd_csi_driver          = true
  enable_cost_allocation     = false
  deletion_protection        = false

  initial_node_count = 1

  # Node pools
  node_pools = [
    {
      name               = var.default_pool_name
      machine_type       = var.default_machine_type
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = var.default_disk_size
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = var.default_initial_nodes
    },
    {
      name               = var.gpu_pool_name
      machine_type       = var.gpu_machine_type
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      spot               = true
      disk_size_gb       = var.gpu_disk_size
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      initial_node_count = var.gpu_initial_nodes
      accelerator_count  = var.gpu_count
      accelerator_type   = var.gpu_type
    }
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }

  node_pools_labels = {
    all = local.tags

    "${var.default_pool_name}" = {
      NodeType = "system"
    }

    "${var.gpu_pool_name}" = {
      NodeType = "gpu"
    }
  }

  node_pools_taints = {
    "${var.gpu_pool_name}" = [
      {
        key    = "nvidia.com/gpu"
        value  = "present"
        effect = "NO_SCHEDULE"
      }
    ]
  }

}
