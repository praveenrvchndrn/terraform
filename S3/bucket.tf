resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.aws_s3_bucket
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = var.aws_s3_bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "lock_file" {
  name         = "lock-files"
  billing_mode = "PAY_PER_REQUEST"   # ← all caps
  hash_key     = "LockID"

  attribute {                        # ← required block
    name = "LockID"
    type = "S"
  }
}