variable "bucket_name" {
    description = "The name of the bucket"
    default = "newsappruntesttf-terraform-state"
    type = string
}

variable "tags" {
    description = "Tags to apply to the bucket"
    default = {
        Name = "Terraform Lock Table"
        createdBy = "infra-newsappruntesttf/backend-support"
    }
    type = map(string)
}