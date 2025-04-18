
resource "aws_lambda_function" "signIn" {
  function_name = "lambda-signin"
  role          = "arn:aws:iam::528038094654:role/LabRole"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout          = 30
  filename      = "${path.module}/signin.zip"

  source_code_hash = filebase64sha256("${path.module}/signin.zip")

   environment {
    variables = {
      AWS_COGNITO_REGION  = var.aws_region
      AWS_COGNITO_USER_POOL_ID = aws_cognito_user_pool.hackathon_admin_pool.id
      AWS_COGNITO_CLIENT_ID = aws_cognito_user_pool_client.hackathon_client.id
    }
  }

  depends_on = [
    aws_cognito_user_pool.hackathon_admin_pool,
    aws_cognito_user_pool_client.hackathon_client
  ]
}

resource "aws_lambda_function" "signUp" {
  function_name = "lambda-signup"
  role          = "arn:aws:iam::528038094654:role/LabRole"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout          = 30
  filename      = "${path.module}/signup.zip"

  source_code_hash = filebase64sha256("${path.module}/signup.zip")

    environment {
    variables = {
      AWS_COGNITO_REGION  = var.aws_region
      AWS_COGNITO_USER_POOL_ID = aws_cognito_user_pool.hackathon_admin_pool.id
      AWS_COGNITO_CLIENT_ID = aws_cognito_user_pool_client.hackathon_client.id
    }
  }

  depends_on = [
    aws_cognito_user_pool.hackathon_admin_pool,
    aws_cognito_user_pool_client.hackathon_client
  ]
}

resource "aws_lambda_function" "authorizer" {
  function_name = "lambda-authorizer"
  role          = "arn:aws:iam::528038094654:role/LabRole"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout          = 30
  filename      = "${path.module}/lambda-authorizer.zip"

  source_code_hash = filebase64sha256("${path.module}/authorizer.zip")

    environment {
    variables = {
      AWS_COGNITO_REGION  = var.aws_region
      AWS_COGNITO_USER_POOL_ID = aws_cognito_user_pool.hackathon_admin_pool.id
      AWS_COGNITO_CLIENT_ID = aws_cognito_user_pool_client.hackathon_client.id
    }
  }

  depends_on = [
    aws_cognito_user_pool.hackathon_admin_pool,
    aws_cognito_user_pool_client.hackathon_client
  ]
}


output "lambda_arns" {
  value = [
    aws_lambda_function.signIn.arn,
    aws_lambda_function.signUp.arn,
    aws_lambda_function.authorizer.arn,
  ]
}
