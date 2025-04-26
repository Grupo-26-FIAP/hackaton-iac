resource "aws_s3_bucket" "file_manager_bucket" {
  bucket = "hackathon-file-manager"
  tags = {
    Name        = "file-manager-bucket"
    Environment = "production"
  }
}

resource "aws_s3_bucket_public_access_block" "file_manager_bucket_public_access_block" {
  bucket = aws_s3_bucket.file_manager_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}