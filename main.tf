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
  region  = "us-east-2"
  #profile = "admin"
}

module "vpc" {
  source             = "./modules/vpc"
  #name               = "my-vpc"
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false 
  azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
