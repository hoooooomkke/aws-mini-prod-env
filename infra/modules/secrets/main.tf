resource "aws_secretsmanager_secret" "slack_webhook" {
  name = "/mini-prod/slack/webhook"
}
output "slack_webhook_name" { value = aws_secretsmanager_secret.slack_webhook.name }
