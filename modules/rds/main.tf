resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "random_password" "mysql" {
  length  = 24
  special = false
}

resource "random_password" "postgres" {
  length  = 24
  special = false
}

resource "aws_secretsmanager_secret" "mysql" {
  name                    = "${var.project_name}/rds/mysql"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({
    username = var.mysql_username
    password = random_password.mysql.result
    host     = aws_db_instance.mysql.address
    port     = 3306
    dbname   = var.mysql_db_name
  })
}

resource "aws_secretsmanager_secret" "postgres" {
  name                    = "${var.project_name}/rds/postgres"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id = aws_secretsmanager_secret.postgres.id
  secret_string = jsonencode({
    username = var.postgres_username
    password = random_password.postgres.result
    host     = aws_db_instance.postgres.address
    port     = 5432
    dbname   = var.postgres_db_name
  })
}

resource "aws_db_instance" "mysql" {
  identifier             = "${var.project_name}-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_name                = var.mysql_db_name
  username               = var.mysql_username
  password               = random_password.mysql.result
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_security_group]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  tags = { Name = "${var.project_name}-mysql" }
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.project_name}-postgres"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_name                = var.postgres_db_name
  username               = var.postgres_username
  password               = random_password.postgres.result
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_security_group]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  tags = { Name = "${var.project_name}-postgres" }
}

