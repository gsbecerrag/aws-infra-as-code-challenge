module "s3" {
    source = "./modules/s3"

    bucket_name = "newsappruntesttf-terraform-infra"
    tags = {
        Name = "Bucket for terraform states of newsappruntesttf"
        createdBy = "infra-newsappruntesttf/backend-support"
    }
}

module "dynamodb" {
    source = "./modules/dynamodb"

    table_name = "newsappruntesttf-terraform-locks"
    read_capacity = 2
    write_capacity = 2
    tags = {
        Name = "Terraform Lock Table"
        createdBy = "infra-newsappruntesttf/backend-support"
    }
}