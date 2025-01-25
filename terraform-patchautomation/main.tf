terraform {
  required_version = ">=0.14"
}

resource "aws_iam_role" "lambda_role" {
  name = "PatchAutomation"

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


resource "aws_iam_policy" "lambda_policy" {
  name        = "PatchAutomation-Policy"
  path        = "/"
  description = "PatchAutomation Lambda policy"
  policy = "${file("./src/config/policy.json")}"
}

resource "aws_iam_role_policy_attachment" "lambda_role_attach" {
  role       = aws_iam_role.centralized_patching_lambda_role.name
  policy_arn = aws_iam_policy.centralized_patching_lambda_policy.arn
}

data "archive_file" "zip_the_code" {
  type = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/src/patch_automation.zip"
}

resource "aws_lambda_function" "patching_lambda" {
  filename      = "${path.module}/src/patch_automation.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "trigger.lambda_handler"
  runtime       ="python3.13"
  depends_on =  [aws_iam_role_policy_attachment.lambda_role_attach]
  memory_size = var.memory_size
  timeout = var.timeout
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.patching_lambda.function_name}"
  retention_in_days = 30
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_function_logfilter" {
  name            = "${aws_lambda_function.patching_lambda.function_name}_logfilter"
  role_arn        = aws_iam_role.centralized_patching_lambda_role.arn
  log_group_name  = "/aws/lambda/${aws_lambda_function.centralized_patching_lambda.function_name}"
  filter_pattern  = ""
  destination_arn = var.kinesis_east
  distribution    = "Random"
}

output "lambda_arn" {
    value = aws_lambda_function.centralized_patching_lambda.arn
    description = "arn of lambda"
}

locals {
  configuration_files_paths = flatten([for p in var.configuration_files_paths : fileset(path.module, p)])

  windows_list = [for f in local.configuration_files_paths : jsondecode(file(f))]

  windows_normalized = merge(local.windows_list...)
}

module "patch_window"{
    source = "./modules/"
    for_each = {for idx, record in local.windows_normalized : idx => record}
    rule_name = each.value.rule_name
    rule_description = each.value.rule_description
    rule_schedule = each.value.rule_schedule
    TagValue = each.value.TagValue
    Environment = each.value.Environment
    PatchOperation = each.value.PatchOperation
    lambda_arn = aws_lambda_function.centralized_patching_lambda.arn
    lambda_name = aws_lambda_function.centralized_patching_lambda.function_name
}