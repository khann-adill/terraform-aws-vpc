variable "create_vpc" {
  type        = bool
  description = "To control if vpc need to create"
  default     = true
}

variable "create_igw" {
  type        = bool
  description = "To control if internet gateways need to create"
  default     = true
}
variable "name" {
  type    = string
  default = ""
}

variable "tags" {
  type        = map(string)
  description = "Additional tag for vpc"
  default     = {}
}
variable "cidr_block" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone"
  type        = bool
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR block for public subnet"
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR block for private subnet"
  default     = []
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "instance_tenancy" {
  description = "A tenancy option to launch instance in VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be tru to enable the DNS hostname in VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be tru to enable the DNS support in VPC"
  type        = bool
  default     = true
}

variable "enable_classiclink" {
  description = "Should be true to enable the ClassicLink for VPC"
  type        = bool
  default     = false
}
