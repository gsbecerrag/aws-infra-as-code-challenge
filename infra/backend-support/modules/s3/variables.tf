variable "bucket_name" {
    description = "The name of the bucket"
    default = "newstftestingtwgsbg2-terraform-state"
    type = string
}

variable "tags" {
    description = "Tags to apply to the bucket"
    default = {
        Name = "Terraform Lock Table"
        createdBy = "infra-newstftestingtwgsbg2/backend-support"
    }
    type = map(string)
}