resource "aws_s3_bucket" "example" {
    bucket = "hackathon-file-manager"
    tags = {
        Name        = "file-manager-bucket"
        Environment = "production"
    }
}