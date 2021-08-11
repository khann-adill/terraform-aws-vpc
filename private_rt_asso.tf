resource "aws_route_table_association" "private-RT-IG-Associatiion" {
  count          = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.Private-Subnet-RT.*.id, count.index)
}
