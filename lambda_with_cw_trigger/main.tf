provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_s3_bucket" "lambda_execution_package_bucket" {
    bucket = "balloonio-lambda-execution-package-bucket"
    acl = "private"
    tags = {
        Purpose = "Lambda"
    }
}

resource "aws_s3_bucket_object" "lambda_execution_package" {
  bucket = "balloonio-lambda-execution-package-bucket"
  key    = "my_function.zip"
  source = "./my_function.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  # etag = "${filemd5("path/to/file")}"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  s3_bucket     = "balloonio-lambda-execution-package-bucket"
  s3_key        = "my_function.zip"
  function_name = "lambda_function_name"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "my_function.my_integ_tester"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  # source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "python3.7"

  environment {
    variables = {
      foo = "bar"
    }
  }
}