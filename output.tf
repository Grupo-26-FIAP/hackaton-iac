output "vpc_id_consumable" {
  value       = aws_vpc.hackathon_vpc.id
  description = "This is the VPC ID for later use"
}

output "private_subnet_1_id" {
  value       = aws_subnet.hackathon_private_subnet_1.id
}

output "private_subnet_2_id" {
  value       = aws_subnet.hackathon_private_subnet_2.id
}

output "public_subnet_1_id" {
  value       = aws_subnet.hackathon_public_subnet_1.id
}

output "public_subnet_2_id" {
  value       = aws_subnet.hackathon_public_subnet_2.id
}


output "product_catalog_service_lb" {
  value = kubernetes_service.product_catalog_service_lb.metadata[0].name
}

output "product_catalog_service_lb_hostname" {
  value = data.kubernetes_service.product_catalog_service.status[0].load_balancer[0].ingress[0].hostname
}
