resource "aws_route_table_association" "RT-IG-Associatiion" {
  count          = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.Public-Subnet-RT[0].id
}
