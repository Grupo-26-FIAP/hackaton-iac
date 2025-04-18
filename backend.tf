terraform {
  backend "s3" {
    bucket = "eks-hackathon-backend-tf"
    key = "hackathon/terraform.tfstate"
    region = "us-east-1"
  }
}