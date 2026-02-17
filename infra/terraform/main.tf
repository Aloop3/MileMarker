locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# -----------------------
# DynamoDB: Vehicles table
# -----------------------
resource "aws_dynamodb_table" "vehicles" {
  name         = "${local.name_prefix}-vehicles"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"
  range_key    = "vehicle_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "vehicle_id"
    type = "S"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------
# DynamoDB: Fuel Logs table
# -----------------------

resource "aws_dynamodb_table" "fuel_logs" {
  name         = "${local.name_prefix}-fuel-logs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "vehicle_id"
  range_key    = "timestamp"

  attribute {
    name = "vehicle_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  attribute {
    name = "fuellog_id"
    type = "S"
  }

  global_secondary_index {
    name            = "fuellog_id-index"
    hash_key        = "fuellog_id"
    projection_type = "ALL"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------
# DynamoDB: Maintenance Records table
# -----------------------

resource "aws_dynamodb_table" "maintenance_records" {
  name         = "${local.name_prefix}-maintenance-records"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "vehicle_id"
  range_key    = "timestamp"

  attribute {
    name = "vehicle_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  attribute {
    name = "maintenance_id"
    type = "S"
  }

  global_secondary_index {
    name            = "maintenance_id-index"
    hash_key        = "maintenance_id"
    projection_type = "ALL"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------
# DynamoDB: Maintenance Records table
# -----------------------
resource "aws_dynamodb_table" "maintenance_notifications" {
  name         = "${local.name_prefix}-maintenance-notifications"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "vehicle_id"
  range_key    = "notification_id"

  attribute {
    name = "vehicle_id"
    type = "S"
  }

  attribute {
    name = "notification_id"
    type = "S"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------
# Cognito: User Pool + App Client
# -----------------------
resource "aws_cognito_user_pool" "user_pool" {
  name = "${local.name_prefix}-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_cognito_user_pool_client" "app_client" {
  name         = "${local.name_prefix}-app-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  # We’ll use the hosted UI later if needed; for now keep auth simple.
  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]

  supported_identity_providers = ["COGNITO"]
}

# -----------------------
# IAM: Lambda execution role
# -----------------------
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${local.name_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# CloudWatch logs
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# DynamoDB access (least privilege to Vehicles table only)
data "aws_iam_policy_document" "lambda_dynamodb" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query"
    ]
    resources = [
      aws_dynamodb_table.vehicles.arn,
      "${aws_dynamodb_table.vehicles.arn}/index/*",
      aws_dynamodb_table.fuel_logs.arn,
      "${aws_dynamodb_table.fuel_logs.arn}/index/*",
      aws_dynamodb_table.maintenance_records.arn,
      "${aws_dynamodb_table.maintenance_records.arn}/index/*",
      aws_dynamodb_table.maintenance_notifications.arn,
      "${aws_dynamodb_table.maintenance_notifications.arn}/index/*"
    ]
  }
}

resource "aws_iam_policy" "lambda_dynamodb" {
  name   = "${local.name_prefix}-lambda-dynamodb"
  policy = data.aws_iam_policy_document.lambda_dynamodb.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb.arn
}

# -----------------------
# Lambda: placeholder
# -----------------------
# For now: a stub zip file must exist locally at apply time.
resource "aws_lambda_function" "api_stub" {
  function_name = "${local.name_prefix}-api"
  role          = aws_iam_role.lambda_role.arn
  handler       = "test_lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = "${path.module}/lambda_stub.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_stub.zip")

  environment {
    variables = {
      VEHICLES_TABLE                  = aws_dynamodb_table.vehicles.name
      FUEL_LOGS_TABLE                 = aws_dynamodb_table.fuel_logs.name
      MAINTENANCE_RECORDS_TABLE       = aws_dynamodb_table.maintenance_records.name
      MAINTENANCE_NOTIFICATIONS_TABLE = aws_dynamodb_table.maintenance_notifications.name
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------
# API Gateway HTTP API + JWT Authorizer
# -----------------------
resource "aws_apigatewayv2_api" "http_api" {
  name          = "${local.name_prefix}-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  api_id          = aws_apigatewayv2_api.http_api.id
  authorizer_type = "JWT"
  name            = "${local.name_prefix}-jwt-auth"

  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.app_client.id]
    issuer   = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
  }
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.api_stub.arn
  payload_format_version = "2.0"
}

# Basic route: GET /health (public) so you can verify API without auth first
resource "aws_apigatewayv2_route" "health" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# Protected example route: GET /vehicle (requires JWT)
resource "aws_apigatewayv2_route" "vehicle" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "GET /vehicle"
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# Allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_stub.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}