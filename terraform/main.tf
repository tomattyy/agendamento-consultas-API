terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  # Configuração para simulação local
  access_key = "test"
  secret_key = "test"

  endpoints {
    s3 = "http://localhost:4566"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
}

resource "aws_s3_bucket" "simulation" {
  bucket = "patient-api-security-simulation"

  tags = {
    Name        = "patient-api-security-simulation"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Purpose     = "Checkov simulation"
  }
}

# Bloqueia acesso público
resource "aws_s3_bucket_public_access_block" "simulation" {
  bucket = aws_s3_bucket.simulation.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versionamento
resource "aws_s3_bucket_versioning" "simulation" {
  bucket = aws_s3_bucket.simulation.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Criptografia
resource "aws_s3_bucket_server_side_encryption_configuration" "simulation" {
  bucket = aws_s3_bucket.simulation.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}