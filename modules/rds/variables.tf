variable "project_name"       { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "db_security_group"  { type = string }
variable "mysql_db_name"      { type = string }
variable "mysql_username"     { type = string }
variable "postgres_db_name"   { type = string }
variable "postgres_username"  { type = string }
variable "db_instance_class"  { type = string }
