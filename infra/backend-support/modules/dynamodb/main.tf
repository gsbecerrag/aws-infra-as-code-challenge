resource "aws_dynamodb_table" "dynamodb_table" {
    name           = var.table_name
    # up to 25 per account is free
    billing_mode   = "PROVISIONED"
    read_capacity  = var.read_capacity
    write_capacity = var.write_capacity
    hash_key       = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    point_in_time_recovery {
        enabled = true
    }

    # set table encryption
    server_side_encryption {
        enabled = true
    }

    tags = var.tags   
}