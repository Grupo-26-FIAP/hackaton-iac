# EKS Cluster
resource "aws_eks_cluster" "hackathon_cluster" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.labrole.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.hackathon_public_subnet_1.id,
      aws_subnet.hackathon_public_subnet_2.id,
      aws_subnet.hackathon_private_subnet_1.id,
      aws_subnet.hackathon_private_subnet_2.id
    ]
    
    security_group_ids = [aws_security_group.eks_security_group.id]
  }

  tags = {
    Name = "hackathon_cluster"
  }
}

data "aws_eks_cluster_auth" "hackathon_cluster_auth" {
  name = aws_eks_cluster.hackathon_cluster.name
}

# EKS Node Group
resource "aws_eks_node_group" "hackathon_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "hackathon_node_group"
  node_role_arn   = data.aws_iam_role.labrole.arn
  subnet_ids      = [
    aws_subnet.hackathon_private_subnet_1.id, 
    aws_subnet.hackathon_private_subnet_2.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  lifecycle {
    prevent_destroy = false
  }

  instance_types = [var.instance_type]
  disk_size      = 20

  ami_type = "AL2_x86_64"

  depends_on = [aws_eks_cluster.hackathon_cluster]

  labels = {
  }

  tags = {
    Name        = "hackathon_node_group"
  }
}

resource "aws_security_group" "eks_security_group" {
  vpc_id = aws_vpc.hackathon_vpc.id
  description = "Allow traffic for EKS Cluster (hackathon)"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-sg"
  }
}
