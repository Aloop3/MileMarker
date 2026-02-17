output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.app_client.id
}

output "api_base_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "VEHICLES_TABLE" {
  value = aws_dynamodb_table.vehicles.name
}

output "FUEL_LOGS_TABLE" {
  value = aws_dynamodb_table.fuel_logs.name
}

output "MAINTENANCE_RECORDS_TABLE" {
  value = aws_dynamodb_table.maintenance_records.name
}

output "MAINTENANCE_NOTIFICATIONS_TABLE" {
  value = aws_dynamodb_table.maintenance_notifications.name
}