output "private_subnet" {
  value       = aws_subnet.private.*.id
  description = "List of private subnets"
}

output "public_subnet" {
  value       = aws_subnet.public.*.id
  description = "List of public subnets"
}

output "vpc_id" {
  value       = local.vpc_id
  description = "VPC ID"
}
