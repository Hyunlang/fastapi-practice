terraform {
  backend "s3" {
    bucket = "monitoring-msa-tfstate"
    key    = "terraform.state"
    region = "ap-northeast-2"
  }
}