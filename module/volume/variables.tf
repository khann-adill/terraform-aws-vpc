variable "size" {
  type        = string
  description = "size of ebs volume"
   default = ""
}

variable "name" {
  type        = string
  description = "volume tag name"
}

variable "tags" {
  type        = map(string)
  description = "Additional tag for volume"
  default     = {}
}

variable "aws_availability_zones" {
  type        = string
  description = "azs for volume"

}

variable "create_vol" {
	type = bool
	description = "To control if volumes needs to  create"
	default = true
}


variable "volume_count" {
	type =string
	description = "no of volumes needed to create"
	default = ""
}
