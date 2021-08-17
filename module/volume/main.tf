resource "aws_ebs_volume" "that" {
  count = var.create_vol ? var.volume_count == "" ? 0 : var.volume_count : 0
  availability_zone = var.aws_availability_zones
  size              = var.size == "" ? 10: var.size
  tags = merge(
    {
      "Name" = format(
      "%s-volume", var.name)
    },
    var.tags,
  )
}
