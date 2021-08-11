resource "aws_route_table" "Public-Subnet-RT" {
  count  = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig[0].id
  }
  tags = merge(
    {
      "Name" = format("%s-public-rt", var.name)
    },
    var.tags,
  )
}
