provider "aws" {
  region = "ap-northeast-2"
}

# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "monitoring-msa-tfstate"

  tags = {
    Name = "testing"
  }
}


resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-lock-test"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}