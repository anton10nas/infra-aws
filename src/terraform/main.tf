
resource "aws_iam_role" "iam_cluster_role" {
  name        = var.iam_role_cluster_name
  description = var.iam_role_cluster_description

  #created manually on aws platform
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect : "Allow",
          Principal : {
            Service : [
              "eks.amazonaws.com"
            ]
          },
          Action : "sts:AssumeRole"
        },
      ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_cluster_role.name
}

resource "aws_iam_role" "iam_nodes_role" {
  name        = var.iam_role_nodes_name
  description = var.iam_role_nodes_description

  #created manually on aws platform
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect : "Allow",
          Principal : {
            Service : [
              "ec2.amazonaws.com"
            ]
          },
          Action : "sts:AssumeRole"
        },
      ]
  })
}

#Needed in all node groups
resource "aws_iam_role_policy_attachment" "iam_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iam_nodes_role.name
}

#Grant access to ec2 and eks
resource "aws_iam_role_policy_attachment" "iam_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iam_nodes_role.name
}

#Read only permissions to elastic container register
resource "aws_iam_role_policy_attachment" "iam_container_register_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iam_nodes_role.name
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.iam_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = [module.vpc.private_subnets[0],module.vpc.private_subnets[1],module.vpc.public_subnets[0],module.vpc.public_subnets[1]]
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam_cluster_policy
  ]
}

resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.iam_nodes_role.arn

  subnet_ids = [module.vpc.private_subnets[0],module.vpc.private_subnets[1]]

  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam_cni_policy,
    aws_iam_role_policy_attachment.iam_worker_node_policy,
    aws_iam_role_policy_attachment.iam_container_register_policy
  ]
}
