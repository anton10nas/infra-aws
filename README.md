# Infra Technical Challenge Task_2

## Goal
The goal of this task was to create a VPC, a kubernetes cluster and a postgresql database in AWS using terraform as Infrustruture as Code.

## Steps
### Environment Setup
Since I didn't work with aws cli for a long time needed to go through the following configuration steps:
- create an AWS account
- install aws cli in my local machine
- setup a new user to be used for this exercise with admin permissions
- add the aws creadentials (secret ID and KEY)
  
### VPC
In order to create the VPC I started by searching a bit about how should be built a VPC to be used on a eks cluster.
To build the VPC I used the official terraform module from terraform registry (https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.14.0)
I decided to create a simple VPC with only 2 public and 2 private subnets:
```
private_subnets = [aws_default_subnet.private_subnet_default.cidr_block, "10.0.96.0/19"]
public_subnets  = [aws_default_subnet.public_subnet_default.cidr_block, "10.0.64.0/19"]
```
I splitted the different subnets in two different availability zones of the us-east-1(Virginia) region.
Since our VPC needs a default subnet, I created two for the different availability zones:
```
resource "aws_default_subnet" "subnet_default_1b" {
  availability_zone = "us-east-1b"

  tags = {
    Name = "Default public subnet for us-east-1b"
  }
}
```

### EKS Cluster
To create the EKS cluster I started by creating the IAM roles:
- iam_cluster_role (IAM role applied on the eks cluster)
  Policies:
   - arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
- iam_nodes_role
  Policies:
  - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
  - arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
  - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

Then I created the node group for the private subnets, applying some scaling configuration and associate the respective iam role policies created.

```
scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }
```

### PostgreSQL Database
Regarding the creation of postgres database, I got some difficulties.
I started by finding the resource that I should use to create an instance od this database, then check which configuration parameters I needed.
In the end I created a database with a security group from the default VPC, because I wasn't being able to added to the same VPC as the eks cluster.

