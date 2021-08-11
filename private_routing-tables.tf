resource "aws_route_table" "Private-Subnet-RT" {
  count  = var.create_vpc && length(var.private_subnets) > 0 && var.one_nat_gateway_per_az ? length(var.private_subnets) : 1
  vpc_id = local.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }
  tags = merge(
    {
      "Name" = format("%s-private-rt-%s", var.name, element(var.azs, count.index))
    },
    var.tags,
  )
}
