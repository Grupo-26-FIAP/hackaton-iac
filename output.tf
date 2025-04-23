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

