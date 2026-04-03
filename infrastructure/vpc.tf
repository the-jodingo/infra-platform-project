# AWS VPC Configuration

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostname = true
  enable_dns_support   = true
  
  tags = {
    Name        = "infra-platform-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_subnet" "private" {
  count = 3
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    Name                                              = "infra-platform-private-${count.index + 1}"
    "kubernetes.io/cluster/infra-platform-eks" = "shared"
    Environment                                       = var.environment
  }
}

resource "aws_eks_cluster" "main" {
  name     = "infra-platform-eks"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.28"
  
  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
}