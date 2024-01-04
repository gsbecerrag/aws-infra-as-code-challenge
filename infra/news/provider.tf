# Setup our aws provider
variable "region" {
  default = "us-east-2"
}
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "newsappruntesttf-terraform-infra"
    region         = "us-east-2"
    dynamodb_table = "newsappruntesttf-terraform-locks"
    key            = "news/terraform.tfstate"
  }
}
