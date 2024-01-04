variable "bucket_name" {
    description = "The name of the bucket"
    default = "news4321-terraform-state"
    type = string
}

variable "tags" {
    description = "Tags to apply to the bucket"
    default = {
        Name = "Terraform Lock Table"
        createdBy = "infra-news4321/backend-support"
    }
    type = map(string)
}