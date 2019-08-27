provider "aws" {
    profile = "ohio"
    region = var.region
}

resource "aws_s3_bucket" "b" {
    bucket = "my-tf-test-bucket-balloonio-whatever-ohio"
    acl = "private"

    tags = {
        Name = "My bucket"
        Environment = "Dev"
        MoreTag = "Im changing this resource"
    }
}

output "s3-region" {
    value = aws_s3_bucket.b.region
}