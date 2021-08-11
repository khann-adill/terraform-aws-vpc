locals {
  vpc_name = "pyrus"
}

resource "aws_vpc" "vpc" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  enable_classiclink   = var.enable_classiclink

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}

#output "vpc_id" {
#  value       = aws_vpc.vpc.id
#  description = "VPC Name"
#}
locals {
  vpc_id = element(
    concat(
      aws_vpc.vpc.*.id,
      [""],
    ),
    0,
  )
}

