# Setup our aws provider
variable "region" {
  default = "us-east-2"
}
provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "news4321-terraform-infra"
    region = "us-east-2"
    dynamodb_table = "news4321-terraform-locks"
    key = "base/terraform.tfstate"
  }
}
