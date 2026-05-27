output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "region" {
  value = var.aws_region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "assets_bucket_name" {
  value = module.s3_lambda.assets_bucket_name
}

output "dev_user_access_key_id" {
  value = module.iam.dev_user_access_key_id
}

output "dev_user_secret_access_key" {
  value     = module.iam.dev_user_secret_access_key
  sensitive = true
}

output "dev_user_console_password" {
  value     = module.iam.dev_user_console_password
  sensitive = true
}

output "rds_mysql_endpoint" {
  value = module.rds.mysql_endpoint
}

output "rds_postgres_endpoint" {
  value = module.rds.postgres_endpoint
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}
