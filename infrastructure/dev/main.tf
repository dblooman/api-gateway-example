variable "aws_region" {
  default = "eu-west-1"
}

module "iam" {
  source = "../modules/iam"
}

output "lambda_function_role_id" {
  value = "${module.iam.lambda_function_role_id}"
}
