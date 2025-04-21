variable "region" {
  description = "AWS Region"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket for storing prowler scan results"
  type        = string
}

variable "lambda_schedule_expression" {
  description = "CloudWatch schedule expression (e.g. rate(1 day))"
  default     = "rate(1 day)"
  type        = string
}

resource "aws_s3_bucket" "prowler_reports" {
  bucket = var.bucket_name

  tags = {
    Name        = "Prowler Reports Bucket"
    Environment = "SecurityMonitoring"
  }
}

resource "aws_s3_bucket_versioning" "prowler_bucket_versioning" {
  bucket = aws_s3_bucket.prowler_reports.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "prowler_lambda_role" {
  name = "prowler-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "prowler_policy" {
  name = "prowler-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.bucket_name}/*",
          "arn:aws:s3:::${var.bucket_name}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:PutMetricData",
          "logs:*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "iam:SimulatePrincipalPolicy",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "organizations:DescribeOrganization",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "ec2:Describe*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_prowler_policy" {
  role       = aws_iam_role.prowler_lambda_role.name
  policy_arn = aws_iam_policy.prowler_policy.arn
}

resource "aws_lambda_function" "prowler_lambda" {
  function_name = "prowler-scan"
  role          = aws_iam_role.prowler_lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  timeout       = 900

  filename         = "${path.module}/lambda_code/prowler_lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_code/prowler_lambda.zip")

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}

resource "aws_cloudwatch_event_rule" "daily_schedule" {
  name                = "prowler-scan-daily"
  schedule_expression = var.lambda_schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_schedule.name
  target_id = "prowlerLambda"
  arn       = aws_lambda_function.prowler_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.prowler_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_schedule.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.prowler_lambda.function_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.prowler_reports.bucket
}
