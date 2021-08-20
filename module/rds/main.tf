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
  name       = "rds-testing"
  subnet_ids = module.vpc.private_subnet

  tags = {
    Name = "rds-testing"
  }
}

resource "aws_security_group" "that" {
  name   = "db-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "db-sg"
  }
}

resource "aws_security_group" "this" {
  name   = "public-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "ssh access"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "public-sg"
  }
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}

resource "aws_db_instance" "that" {
  identifier             = "rds-dev"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0.25"
  username               = "pyrus"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.that.name
  vpc_security_group_ids = [aws_security_group.that.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.that.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.that.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.that.username
}
