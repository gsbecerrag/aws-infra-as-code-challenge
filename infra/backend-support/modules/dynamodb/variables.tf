variable "table_name" {
    description = "value"
    default = "newsnews4321-terraform-locks"
    type = string
}

variable "read_capacity" {
    description = "value"
    default = 2
    type = number
}

variable "write_capacity" {
    description = "value"
    default = 2
    type = number
}

variable "tags" {
    description = "value"
    default = {
        Name = "Terraform Lock Table"
        createdBy = "infra-newsnews4321/backend-support"
    }
    type = map(string)
}