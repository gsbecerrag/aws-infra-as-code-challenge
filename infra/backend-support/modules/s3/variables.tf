variable "bucket_name" {
    description = "The name of the bucket"
    default = "newsnews4321-terraform-state"
    type = string
}

variable "tags" {
    description = "Tags to apply to the bucket"
    default = {
        Name = "Terraform Lock Table"
        createdBy = "infra-newsnews4321/backend-support"
    }
    type = map(string)
}