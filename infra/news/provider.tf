# Setup our aws provider
variable "region" {
  default = "us-east-2"
}
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "newstftestingtwgsbg2-terraform-infra"
    region         = "us-east-2"
    dynamodb_table = "newstftestingtwgsbg2-terraform-locks"
    key            = "news/terraform.tfstate"
  }
}
