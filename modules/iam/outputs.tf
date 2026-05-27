output "dev_user_access_key_id" {
  value = aws_iam_access_key.dev_view.id
}

output "dev_user_secret_access_key" {
  value     = aws_iam_access_key.dev_view.secret
  sensitive = true
}

output "dev_user_console_password" {
  value     = aws_iam_user_login_profile.dev_view.password
  sensitive = true
}
