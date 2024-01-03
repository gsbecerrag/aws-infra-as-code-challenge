module "s3" {
    source = "./modules/s3"

    bucket_name = "news4321-terraform-infra"
    tags = {
        Name = "Bucket for terraform states of news4321"
        createdBy = "infra-news4321/backend-support"
    }
}

module "dynamodb" {
    source = "./modules/dynamodb"

    table_name = "news4321-terraform-locks"
    read_capacity = 2
    write_capacity = 2
    tags = {
        Name = "Terraform Lock Table"
        createdBy = "infra-news4321/backend-support"
    }
}