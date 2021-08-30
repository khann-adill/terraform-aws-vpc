terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = "ap-south-1"
  profile = "admin"
}

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

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )
  lifecycle {
    create_before_destroy = true
  }
}
