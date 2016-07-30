variable "account_id" {}

resource "aws_api_gateway_rest_api" "hello" {
  name = "Hello World API"
  description = "Example of Apex's Terraform integration"
}

resource "aws_api_gateway_resource" "hello" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  parent_id = "${aws_api_gateway_rest_api.hello.root_resource_id}"
  path_part = "hello"
}

resource "aws_api_gateway_method" "hello_get" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.hello.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.hello.id}"
  http_method = "${aws_api_gateway_method.hello_get.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "hello" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.hello.id}"
  http_method = "${aws_api_gateway_method.hello_get.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_integration" "hello_get" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.hello.id}"
  http_method = "${aws_api_gateway_method.hello_get.http_method}"
  type = "AWS"
  integration_http_method = "POST" # Must be POST for invoking Lambda function
  credentials = "${aws_iam_role.gateway_invoke_lambda.arn}"
  # http://docs.aws.amazon.com/apigateway/api-reference/resource/integration/#uri
  uri = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:${var.account_id}:function:dblooman-lambda_hello/invocations"
}

resource "aws_api_gateway_deployment" "dev" {
  depends_on = ["aws_api_gateway_integration.hello_get"]

  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  stage_name = "dev"
}

resource "aws_api_gateway_resource" "dynamo_get_latest" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  parent_id = "${aws_api_gateway_rest_api.hello.root_resource_id}"
  path_part = "dynamo"
}

resource "aws_api_gateway_method" "dynamo_get_latest" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.dynamo_get_latest.id}"
  http_method = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "dynamo_200" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.dynamo_get_latest.id}"
  http_method = "${aws_api_gateway_method.dynamo_get_latest.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "dynamo" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.dynamo_get_latest.id}"
  http_method = "${aws_api_gateway_method.dynamo_get_latest.http_method}"
  status_code = "${aws_api_gateway_method_response.dynamo_200.status_code}"
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_integration" "dynamo_get_latest" {
  rest_api_id = "${aws_api_gateway_rest_api.hello.id}"
  resource_id = "${aws_api_gateway_resource.dynamo_get_latest.id}"
  http_method = "${aws_api_gateway_method.dynamo_get_latest.http_method}"
  type = "AWS"
  integration_http_method = "POST" # Must be POST for invoking Lambda function
  credentials = "${aws_iam_role.gateway_invoke_lambda.arn}"
  uri = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:${var.account_id}:function:dblooman-lambda_dynamo/invocations"
}
