terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws        = { source = "hashicorp/aws",        version = "~> 5.0" }
    kubernetes = { source = "hashicorp/kubernetes",  version = "~> 2.0" }
    helm       = { source = "hashicorp/helm",        version = "~> 2.0" }
    tls        = { source = "hashicorp/tls",         version = "~> 4.0" }
  }

  backend "s3" {
    bucket = "project-bedrock-tfstate-karatu-024"  # change this
    key    = "bedrock/terraform.tfstate"
    region = "us-east-1"
  }
}
