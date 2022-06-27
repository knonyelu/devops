resource "aws_iam_role" "prod-ci-role" {
  name = "prod-ci-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
}


resource "aws_iam_policy" "prod-ci-policy" {
  name        = "prod-ci-policy"
  path        = "/"
  description = "Prod CI Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.prod-ci-role.arn
      },
    ]
  })
}

resource "aws_iam_group" "prod-ci-group" {
  name = "prod-ci-group"
}   

resource "aws_iam_user" "prod-ci-user" {
  name = "prod-ci-user"
}

resource "aws_iam_user_group_membership" "prod-ci-user" {
  user = aws_iam_user.prod-ci-user.name
  groups = [
    aws_iam_group.prod-ci-group.name,
  ]
}

