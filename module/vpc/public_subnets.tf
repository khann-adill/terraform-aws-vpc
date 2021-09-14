resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id                  = local.vpc_id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  #availability_zone       = length(regexall("^[a-z]{1}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone       = length(element(var.azs, count.index)) > 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format(
      "%s-public-%s", var.name, element(var.azs, count.index))
    },
    var.tags,
  )
}
