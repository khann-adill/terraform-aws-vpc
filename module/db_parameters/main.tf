locals{
  name        = var.use_name_prefix && var.create ? null : var.name
  name_prefix = var.use_name_prefix ? "${var.name}-" : null
  description = coalesce(var.description, format("%s parameter group", var.name))
}

resource "aws_db_parameter_group" "that" {

  name        = local.name
  description = local.description
  name_prefix = local.name_prefix
  family      = var.family
  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
