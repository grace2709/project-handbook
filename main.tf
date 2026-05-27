provider "aws" {
  region = var.aws_region
  default_tags {
    tags = { Project = "karatu-2025-capstone" }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}

module "vpc" {
  source             = "./modules/vpc"
  project_name       = var.project_name
  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
}

module "security_groups" {
  source       = "./modules/security-groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr
}

module "eks" {
  source             = "./modules/eks"
  project_name       = var.project_name
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  node_instance_type = var.node_instance_type
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
  node_desired_size  = var.node_desired_size
  aws_region         = var.aws_region
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  db_security_group  = module.security_groups.rds_sg_id
  mysql_db_name      = var.mysql_db_name
  mysql_username     = var.mysql_username
  postgres_db_name   = var.postgres_db_name
  postgres_username  = var.postgres_username
  db_instance_class  = var.db_instance_class
}

module "dynamodb" {
  source       = "./modules/dynamodb"
  project_name = var.project_name
}

module "iam" {
  source            = "./modules/iam"
  project_name      = var.project_name
  assets_bucket_arn = module.s3_lambda.assets_bucket_arn
}

module "s3_lambda" {
  source       = "./modules/s3-lambda"
  project_name = var.project_name
  student_id   = var.student_id
}
