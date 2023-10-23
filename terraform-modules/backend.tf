# resource "aws_s3_bucket" "terraform-state" {
#   bucket = "ze-terraform-statefile"
#   lifecycle {
#     #    prevent_destroy = true
#   }
# }



# resource "aws_s3_bucket_versioning" "enabled" {
#   bucket = aws_s3_bucket.terraform-state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_dynamodb_table" "terraform-lockstate" {
#   name         = "terraform-lockstate"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }






# terraform {
#   backend "s3" {
#     bucket         = "ze-terraform-statefile"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-lockstate"
#     encrypt        = "true"
#   }
# }