terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_iam_role" "lambda_role" {
  name = "simple-flask-app-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_ecr_repository_policy" "lambda_access" {
  repository = "simple-flask-app"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "LambdaECRImageAccess"
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}

resource "aws_lambda_function" "staging" {
  function_name = "simple-flask-app-staging"

  package_type = "Image"

  image_uri = var.ecr_image_identifier

  role = aws_iam_role.lambda_role.arn

  timeout     = 30
  memory_size = 512

  architectures = ["x86_64"]
}

variable "ecr_image_identifier" {
  description = "The full URI of the Docker image in ECR."
  type        = string
}

output "lambda_function_name" {
  value = aws_lambda_function.staging.function_name
}