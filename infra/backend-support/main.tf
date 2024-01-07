module "s3" {
    source = "./modules/s3"

    bucket_name = "newsnews4321-terraform-infra"
    tags = {
        Name = "Bucket for terraform states of newsnews4321"
        createdBy = "infra-newsnews4321/backend-support"
    }
}

module "dynamodb" {
    source = "./modules/dynamodb"

    table_name = "newsnews4321-terraform-locks"
    read_capacity = 2
    write_capacity = 2
    tags = {
        Name = "Terraform Lock Table"
        createdBy = "infra-newsnews4321/backend-support"
    }
}