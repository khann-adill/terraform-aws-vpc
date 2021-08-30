# Play-with-terraform
### Calling VPC module
```
module "vpc" {
  source                 = "./module/vpc"
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

output "private_subnet" {
    value = module.vpc.private_subnet
}

output "public_subnet" {
    value = module.vpc.public_subnet
}

output "vpc_id" {
    value = module.vpc.vpc_id
}

```
### Calling volume EBS module
```
module "ebs-volume" {
  source = "git::https://github.com/khann-adill/terraform-aws-vpc.git//module/volume"
  name   = "ebs_volume"
  aws_availability_zones = "us-east-2a"
  size   = "20"
  volume_count = "3"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

### Calling DB Parameter group module
```
module "db_params" {
  source          = "git::https://github.com/khann-adill/terraform-aws-vpc.git//module/db_parameters"
  family          = "mysql8.0"
  name            = "mysqldbparam"
  use_name_prefix = "true"
  prefix_name     = "mysql"
  description     = "db parameter for mysql db"
  parameters = [
    {
      name  = "sort_buffer_size"
      value = "2097152"
    }
  ]
  tags = {
    Terraform   = "true"
    Environment = "dev"
    RDS         = "mysql-dev"
  }
}
output "db_parameter_group_id" {
  value = module.db_params.db_parameter_group_id
}
```
