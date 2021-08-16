# terraform-aws-vpc
```
module "vpc" {
  source                 = "git::https://github.com/khann-adill/terraform-aws-vpc.git//module/vpc"
  name                   = "my-vpc"
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  azs                    = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets        = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```
