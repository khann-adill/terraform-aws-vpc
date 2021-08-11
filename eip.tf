locals {

  nat_gateway_count = var.single_nat_gateway ? 1 : length(var.azs)
}

resource "aws_eip" "eip" {

  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0
  vpc   = true
  tags = merge(
    {
      "Name" = format("%s-eip-%s", var.name, element(var.azs, var.single_nat_gateway ? 0 : count.index))
    },
    var.tags,
  )
}
