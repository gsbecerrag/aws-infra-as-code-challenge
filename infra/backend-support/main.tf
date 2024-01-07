module "s3" {
    source = "./modules/s3"

    bucket_name = "newstftestingtwgsbg2-terraform-infra"
    tags = {
        Name = "Bucket for terraform states of newstftestingtwgsbg2"
        createdBy = "infra-newstftestingtwgsbg2/backend-support"
    }
}

module "dynamodb" {
    source = "./modules/dynamodb"

    table_name = "newstftestingtwgsbg2-terraform-locks"
    read_capacity = 2
    write_capacity = 2
    tags = {
        Name = "Terraform Lock Table"
        createdBy = "infra-newstftestingtwgsbg2/backend-support"
    }
}