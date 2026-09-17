variable "aws_region" {
  description = "The AWS region for our resources."
  type        = string
  default     = "eu-west-3"
}

variable "random_suffix" {
  description = "A random suffix to ensure the bucket name is unique."
  type        = string
}