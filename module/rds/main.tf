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
  profile = "admin"
}
module "vpc" {
  source                 = "git::https://github.com/khann-adill/terraform-aws-vpc.git//module/vpc"
  name                   = "rds-vpc"
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  azs                    = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets         = ["10.0.1.0/24"]
  private_subnets        = ["10.0.2.0/24", "10.0.3.0/24"]
  tags = {
    Terraform   = "true"
    Environment = "dev"
    RDS         = "mysql-dev"
  }
}

#output "private_subnet" {
#    value = module.vpc.private_subnet
#}

#output "public_subnet" {
#    value = module.vpc.public_subnet
#}

#output "vpc_id" {
#    value = module.vpc.vpc_id
#}

resource "aws_db_subnet_group" "that" {
	name = "rds-testing"
	subnet_ids = module.vpc.private_subnet

	tags = {
	Name = "rds-testing"
	}
}

resource "aws_security_group" "that" {
        name = "rds_security_group"
        vpc_id = module.vpc.vpc_id

        ingress {
          from_port = 3306
	  to_port = 3306
	  protocol = "tcp"
	  cidr_blocks = ["0.0.0.0/0"]
          security_group_id = aws_security_group.this.id
	}

	egress {
         from_port   = 3306
         to_port     = 3306
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
         Name = "rds-sg"
        }
}

resource "aws_security_group" "this" {
        name = "rds_public_access"
        vpc_id = module.vpc.vpc_id

        ingress {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          description = "ssh access"
          cidr_blocks = ["0.0.0.0/0"]
         }

        egress {
         from_port   = 3306
         to_port     = 3306
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
         Name = "rds-public-sg"
        }
}

resource "aws_db_instance" "that" {
  identifier             = "rds-dev"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0.25"
  username               = "pyrus"
  password               = "khannadill"
  db_subnet_group_name   = aws_db_subnet_group.that.name
  vpc_security_group_ids = [aws_security_group.that.id]
#  parameter_group_name   = aws_db_parameter_group.that.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}
