module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-antonio"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.32.0/19", "10.0.96.0/19"]
  public_subnets  = ["10.0.0.0/19", "10.0.64.0/19"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "env-1"
  }
}

resource "aws_default_subnet" "subnet_default_1a" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default public subnet for us-east-1a"
  }
}

resource "aws_default_subnet" "subnet_default_1b" {
  availability_zone = "us-east-1b"

  tags = {
    Name = "Default public subnet for us-east-1b"
  }
}