# LLM-Ops Infrastructure

This repository contains Terraform configurations for deploying Kubernetes clusters optimized for Large Language Model (LLM) operations on major cloud providers.

## 🚀 Features

- **Multi-Cloud Support**: Deploy on Google Cloud Platform (GKE), Microsoft Azure (AKS), and Amazon Web Services (EKS)
- **GPU-Optimized**: Pre-configured GPU node pools for ML/AI workloads
- **Cost-Effective**: Spot/Preemptible instances for development and testing whereever possible
- **Security-First**: Private clusters with proper network policies
- **Production-Ready**: Auto-scaling, monitoring, and logging included
- **Standardized**: Consistent configuration patterns across cloud providers

## 📁 Repository Structure

```
├── GCP/              # Google Cloud Platform (GKE)
│   ├── main.tf       # Provider and backend configuration
│   ├── variables.tf  # Variable definitions
│   ├── gke.tf       # GKE cluster configuration
│   ├── outputs.tf   # Output values
│   └── terraform.tfvars.example
├── Azure/            # Microsoft Azure (AKS)
│   ├── main.tf       # Provider and backend configuration
│   ├── variables.tf  # Variable definitions
│   ├── aks.tf       # AKS cluster configuration
│   ├── outputs.tf   # Output values
│   └── terraform.tfvars.example
├── AWS/              # Amazon Web Services (EKS)
│   ├── main.tf       # Provider and backend configuration
│   ├── variables.tf  # Variable definitions
│   ├── eks.tf        # EKS cluster configuration
│   ├── vpc.tf        # VPC and networking
│   ├── iam.tf        # IAM roles and policies
│   ├── outputs.tf    # Output values
│   └── terraform.tfvars.example
└── README.md
```

## 🛠 Prerequisites

### Common Requirements
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- Cloud provider CLI tools
- Appropriate cloud provider permissions

### Google Cloud Platform
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP Project with billing enabled
- Required APIs enabled:
  - Kubernetes Engine API
  - Compute Engine API
  - Container Registry API

### Microsoft Azure
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription
- Resource provider registrations:
  - Microsoft.ContainerService
  - Microsoft.Compute
  - Microsoft.OperationalInsights

### Amazon Web Services
- [AWS CLI](https://aws.amazon.com/cli/)
- AWS account with appropriate permissions
- Required permissions:
  - EKS cluster management
  - EC2 instance management
  - VPC networking
  - IAM role creation

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone <repository-url>
cd llm-ops
```

### 2. Choose Your Cloud Provider

#### Google Cloud Platform (GKE)
```bash
cd GCP
cp terraform.tfvars.example terraform.tfvars
```

#### Microsoft Azure (AKS)
```bash
cd Azure
cp terraform.tfvars.example terraform.tfvars
```

#### Amazon Web Services (EKS)
```bash
cd AWS
cp terraform.tfvars.example terraform.tfvars
```

### 3. Configure Variables
Edit `terraform.tfvars` with your specific values:

**GCP Example:**
```hcl
project_id = "your-gcp-project"
region     = "us-central1"
zone       = "us-central1-a"

# Machine types - adjust based on your needs
default_machine_type = "e2-standard-2"
gpu_machine_type     = "n1-highmem-2"
```

**Azure Example:**
```hcl
resource_group_name = "your-resource-group"
location           = "East US"

# VM sizes - adjust based on your needs
default_vm_size = "Standard_D2s_v4"
gpu_vm_size     = "Standard_NC4as_T4_v3"
```

**AWS Example:**
```hcl
region          = "us-east-1"
cluster_name    = "llmops-cluster"
vpc_cidr        = "10.0.0.0/16"

# Instance types - adjust based on your needs
system_instance_type = "t3.medium"
gpu_instance_type    = "g4dn.xlarge"
```

### 4. Configure Backend (Optional)
Update the backend configuration in `main.tf` for your state storage:

**GCP (Google Cloud Storage):**
```hcl
backend "gcs" {
  bucket = "your-terraform-state-bucket"
  prefix = "gke/terraform.tfstate"
}
```

**Azure (Azure Storage):**
```hcl
backend "azurerm" {
  resource_group_name  = "your-terraform-state-rg"
  storage_account_name = "yourtfstate"
  container_name       = "tfstate"
  key                  = "aks/terraform.tfstate"
}
```

**AWS (S3):**
```hcl
backend "s3" {
  bucket = "your-terraform-state-bucket"
  key    = "eks/terraform.tfstate"
  region = "us-east-1"
}
```

### 5. Deploy Infrastructure
```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

### 6. Connect to Your Cluster

#### GKE
```bash
gcloud container clusters get-credentials cluster-1 --zone=us-central1-a --project=your-project
```

#### AKS
```bash
az aks get-credentials --resource-group your-rg --name cluster-1
```

#### EKS
```bash
aws eks update-kubeconfig --region us-east-1 --name llmops-cluster
```

## 🎯 Configuration Options

### Cluster Features

| Feature | GKE | AKS | EKS | Description |
|---------|-----|-----|-----|-------------|
| **Private Cluster** | ✅ | ✅ | ✅ | Nodes have private IPs only |
| **Auto-scaling** | ⚠️ | ✅ | ✅ | Limited scaling (GKE), full auto-scaling (AKS/EKS) |
| **GPU Support** | ✅ | ✅ | ✅ | NVIDIA GPU node pools |
| **Spot Instances** | ⚠️ | ⚠️ | ✅ | GPU only (GKE), quota limited (AKS), enabled (EKS) |
| **Monitoring** | ⚠️ | ✅ | ⚠️ | Basic (GKE), Log Analytics (AKS), CloudWatch (EKS) |
| **Network Policies** | ❌ | ✅ | ⚠️ | Disabled (GKE), enabled (AKS), configurable (EKS) |

### Default Configurations

#### GKE (Google Cloud)
- **Network**: Default VPC with auto-created secondary ranges
- **Node Pools**:
  - Default: `e2-standard-2` (2 vCPU, 8 GB RAM)
  - GPU: `n1-highmem-2` + `nvidia-tesla-t4`
- **Kubernetes Version**: Latest stable
- **Region**: Multi-zonal deployment

#### AKS (Azure)
- **Network**: Azure CNI with Azure network policies
- **Node Pools**:
  - Default: `Standard_D2s_v4` (2 vCPU, 8 GB RAM)
  - GPU: `Standard_NC4as_T4_v3` (4 vCPU, 28 GB RAM + T4 GPU)
- **Kubernetes Version**: 1.31
- **Tier**: Free (can be upgraded to Standard)

#### EKS (AWS)
- **Network**: Custom VPC with private/public subnets
- **Node Groups**:
  - System: `t3.medium` (2 vCPU, 4 GB RAM)
  - GPU: `g4dn.xlarge` (4 vCPU, 16 GB RAM + T4 GPU)
- **Kubernetes Version**: 1.31
- **Managed**: Fully managed control plane

### GPU Configuration

All platforms include GPU node pools with:
- Proper GPU taints for workload isolation
- GPU drivers automatically installed
- Suitable for AI/ML workloads including:
  - Training small to medium models
  - Inference deployments
  - Jupyter notebooks
  - MLflow experiments

## 💰 Cost Optimization

### Spot Instances
- **GKE**: GPU nodes use spot instances (60-90% cost savings), system nodes use regular instances
- **AKS**: GPU nodes configured as Regular priority due to typical quota limitations for Low Priority Cores
- **EKS**: GPU nodes use SPOT instances, system nodes use ON_DEMAND for stability

### Auto-scaling
- **GKE**: Limited auto-scaling (min=max=1 for default setup) - can be modified for production
- **AKS**: Full auto-scaling enabled (1-3 nodes for system pool)
- **EKS**: Full auto-scaling enabled (0-1 GPU nodes, 1-3 system nodes)
- Cost allocation tags for tracking

### Resource Sizing
- Conservative defaults suitable for development
- Scale up for production workloads
- Adjust machine types based on your requirements

## 🔒 Security Features

- **Private Clusters**: Nodes isolated from public internet
- **Network Policies**: Pod-to-pod communication controls (enabled on AKS, configurable on EKS, disabled by default on GKE)
- **RBAC**: Role-based access control enabled
- **Workload Identity** (GKE): Secure access to cloud services
- **Azure AD Integration** (AKS): Centralized identity management

## 🧪 Example Workloads

### GPU Workload Example
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-test
spec:
  tolerations:
  - key: "nvidia.com/gpu"
    operator: "Equal"
    value: "present"
    effect: "NoSchedule"
  containers:
  - name: gpu-container
    image: nvidia/cuda:11.8-runtime-ubuntu20.04
    resources:
      limits:
        nvidia.com/gpu: 1
```

## 🚨 Important Notes

### Quotas and Limits
- **GCP**: Check GPU quotas in your region
- **Azure**: Verify Low Priority Core quotas for spot instances
- Request quota increases if needed

### Costs
- GPU instances incur significant costs
- Monitor usage and scale down when not needed
- Consider spot/preemptible instances for development

### Network Configuration
- Default configurations use cloud provider defaults
- For production, consider custom VPC/VNet configurations
- Firewall rules may need adjustment based on requirements

## 🔧 Customization

### Adding More Node Pools
Extend the `node_pools` configuration in `gke.tf` or add more `azurerm_kubernetes_cluster_node_pool` resources in `aks.tf`.

### Different GPU Types
- **GCP**: `nvidia-tesla-t4`, `nvidia-tesla-v100`, `nvidia-tesla-a100`
- **Azure**: `Standard_NC*_T4_v3`, `Standard_NC*_V100_v3`, `Standard_ND*_A100_v4`
- **AWS**: `g4dn.*` (T4), `p3.*` (V100), `p4d.*` (A100)

### Networking
- Modify VPC/VNet configurations in the respective cloud folders
- Add custom subnets, security groups, or network policies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This infrastructure is designed for development and testing purposes. For production deployments:

- Review security configurations
- Implement proper backup strategies
- Set up monitoring and alerting
- Follow your organization's compliance requirements
- Consider high availability and disaster recovery

## 🆘 Support

- **Issues**: Open an issue in this repository
- **Documentation**: See cloud provider documentation for detailed configuration options
- **Community**: Join cloud-native and Kubernetes communities for support

---

**Happy LLM Operations! 🚀**