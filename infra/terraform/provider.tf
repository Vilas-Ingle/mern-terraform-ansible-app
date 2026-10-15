provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "mern-terraform-ansible"
      Environment = "assignment"
      ManagedBy   = "Terraform"
    }
  }
}
