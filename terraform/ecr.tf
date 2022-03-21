resource "aws_ecr_repository" "api-ecr-repo" {
  name                 = "monitoring-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}