aws_eks_cluster = {
  this = {
    cluster_name    = "antonio_cluster"
    cluster_version = "1.21"
  }
}

aws_eks_node_group = {
  private_nodes = {
    node_group_name = "private_node_group"
  }
}

aws_iam_role = {
  iam_cluster_role = {
    iam_role_cluster_name        = "cluster_iam_role"
    iam_role_cluster_description = "EKS cluster iam role"
  }
  iam_nodes_role = {
    iam_role_nodes_name        = "nodes_iam_role"
    iam_role_nodes_description = "Nodes iam role"
  }
}

aws_security_group = {
  db_sg = {
    db_sg_name = "db_security_group"
  }
}

aws_db_instance = {
  postgres_db = {
    db_identifier = "postgres-db"
    db_name       = "postgresdb"
    db_username   = "antonio"
  }
}

