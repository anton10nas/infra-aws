#EKS Cluster variables
variable "cluster_name" {
  description = "Name of the cluster created"
  type        = string
  default     = "antonio_cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = null
}

variable "iam_role_cluster_name" {
  description = "The cluster IAM role name"
  type        = string
  default     = "cluster_iam"
}

variable "iam_role_cluster_description" {
  description = "The cluster IAM role description"
  type        = string
  default     = ""
}

#Node groups variables
variable "node_group_name" {
  description = "Name of the node group "
  type        = string
  default     = ""
}

variable "iam_role_nodes_name" {
  description = "The nodes IAM role name"
  type        = string
  default     = "node_iam"
}

variable "iam_role_nodes_description" {
  description = "The nodes IAM role description"
  type        = string
  default     = ""
}

#Postgres db variables
variable "db_sg_name" {
  description = "Security Group of the db"
  type        = string
  default     = ""
}

variable "db_identifier" {
  description = "db identifier"
  type        = string
  default     = "db-identifier"
}

variable "db_name" {
  description = "db name"
  type        = string
  default     = "dbname"
}

variable "db_username" {
  description = "db username"
  type        = string
  default     = "username"
}



