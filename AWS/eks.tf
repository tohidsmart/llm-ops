module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  # Network configuration
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Cluster access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Use explicit IAM roles
  create_iam_role = false
  iam_role_arn    = aws_iam_role.cluster_role.arn

  # Cluster addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    aws-ebs-csi-driver     = {}
  }

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    # System node group
    system_nodes = {
      name           = "system-nodes"
      instance_types = [var.system_instance_type]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 3
      desired_size = 1

      disk_size = 20

      subnet_ids = module.vpc.private_subnets

      # Use explicit IAM role
      create_iam_role = false
      iam_role_arn    = aws_iam_role.nodegroup_role.arn

      labels = {
        NodeType = "system"
      }

      tags = {
        NodeType    = "system"
        Environment = "dev"
      }
    }

    # GPU node group
    gpu_nodes = {
      name           = "gpu-nodes"
      instance_types = [var.gpu_instance_type]
      capacity_type  = "SPOT"

      min_size     = 0
      max_size     = 1
      desired_size = 1

      disk_size = 200
      ami_type  = "BOTTLEROCKET_x86_64_NVIDIA"

      subnet_ids = module.vpc.private_subnets

      # Use explicit IAM role
      create_iam_role = false
      iam_role_arn    = aws_iam_role.nodegroup_role.arn

      labels = {
        NodeType = "gpu"
      }

      taints = [
        {
          key    = "nvidia.com/gpu"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ]

      tags = {
        NodeType    = "gpu"
        Environment = "dev"
      }
    }
  }

  # Cluster access management
  access_entries = {
    cluster_creator = {
      kubernetes_groups = []
      principal_arn     = data.aws_caller_identity.current.arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = local.tags
}

data "aws_caller_identity" "current" {}
