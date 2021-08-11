resource "aws_nat_gateway" "nat" {
  count         = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0
  allocation_id = element(aws_eip.eip.*.id, var.single_nat_gateway ? 0 : count.index)
  subnet_id     = element(aws_subnet.public.*.id, var.single_nat_gateway ? 0 : count.index)
  tags = merge(
    {
      "Name" = format(
        "%s-nat-%s",
        var.name,
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
  )
  depends_on = [aws_internet_gateway.ig]

}
