resource "aws_iam_user" "dev_view" {
  name          = "bedrock-dev-view"
  force_destroy = true
}

resource "random_password" "dev_console" {
  length  = 16
  special = true
}

resource "aws_iam_user_login_profile" "dev_view" {
  user                    = aws_iam_user.dev_view.name
  password_reset_required = false
  password_length         = 16
}

resource "aws_iam_access_key" "dev_view" {
  user = aws_iam_user.dev_view.name
}

resource "aws_iam_user_policy_attachment" "readonly" {
  user       = aws_iam_user.dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy" "s3_put" {
  user = aws_iam_user.dev_view.name
  name = "bedrock-dev-s3-put"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:PutObject"
      Resource = "${var.assets_bucket_arn}/*"
    }]
  })
}
