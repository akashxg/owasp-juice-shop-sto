# INTENTIONALLY INSECURE — for Harness STO + Wiz IaC scan demo only.
# Do NOT apply to a real AWS account.

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "juice_shop_open" {
  name        = "juice-shop-open-sg"
  description = "Intentionally open security group for STO demo"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "juice_shop_public" {
  bucket = "juice-shop-sto-demo-public-bucket"
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "juice_shop_public" {
  bucket = aws_s3_bucket.juice_shop_public.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_iam_policy" "juice_shop_admin" {
  name        = "juice-shop-overprivileged"
  description = "Intentionally over-permissive IAM policy for STO demo"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_db_instance" "juice_shop_db" {
  identifier              = "juice-shop-demo-db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = "admin"
  password                = "HardcodedDbPassword123!"
  publicly_accessible     = true
  storage_encrypted         = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.juice_shop_open.id]
}
