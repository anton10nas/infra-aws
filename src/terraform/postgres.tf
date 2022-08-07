
resource "random_string" "db-password" {
  length  = 32
  upper   = true
  number  = true
  special = false
}

resource "aws_security_group" "db_sg" {
  name   = var.db_sg_name

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres_db" {
  identifier             = var.db_identifier
  db_name                = var.db_name
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "12.7"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  username               = var.db_username
  password               = random_string.db-password.result
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

