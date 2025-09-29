# Enable required APIs
resource "google_project_service" "container" {
  project = var.project_id
  service = "container.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

# Service account for GPU workloads with Workload Identity
resource "google_service_account" "gpu_workload_sa" {
  project      = var.project_id
  account_id   = "${var.cluster_name}-gpu-workload"
  display_name = "GPU Workload Service Account"
  description  = "Service account for GPU workloads in GKE cluster"
}

# IAM binding for Workload Identity
resource "google_service_account_iam_binding" "gpu_workload_identity" {
  service_account_id = google_service_account.gpu_workload_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/gpu-workload-ksa]"
  ]
}

# Grant necessary permissions to the service account
resource "google_project_iam_member" "gpu_workload_storage" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gpu_workload_sa.email}"
}

resource "google_project_iam_member" "gpu_workload_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gpu_workload_sa.email}"
}

resource "google_project_iam_member" "gpu_workload_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gpu_workload_sa.email}"
}