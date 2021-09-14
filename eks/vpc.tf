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
  profile = "eksadmin"
}

module "vpc" {
  source                 = "git::https://github.com/khann-adill/terraform-aws-vpc.git//module/vpc"
  name                   = "eks_vpc"
  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  azs                    = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  public_subnets         = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets        = []
  tags = {
    Terraform   = "true"
    Environment = "dev"
    VPC         = "eks_vpc"
  }
}
output "public_subnet" {
    value = module.vpc.public_subnet
}

output "vpc_id" {
    value = module.vpc.vpc_id
}
