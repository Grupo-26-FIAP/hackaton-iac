terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = aws_eks_cluster.hackathon_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.hackathon_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.hackathon_cluster_auth.token
}
