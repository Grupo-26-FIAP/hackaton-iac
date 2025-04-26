
resource "aws_cognito_user_pool" "hackathon_admin_pool" {
  name = "hackathon-admin-pool"
  schema {
    attribute_data_type = "String"
    name                = "name"
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }
  password_policy {
    minimum_length = 6
  }
  username_attributes      = []
  mfa_configuration        = "OFF"
  auto_verified_attributes = ["email"]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

}

resource "aws_cognito_user_pool_domain" "hackathon-domain" {
  domain       = "hackathon-domain"
  user_pool_id = aws_cognito_user_pool.hackathon_admin_pool.id
}

resource "aws_cognito_user_pool_client" "hackathon_client" {
  name                                 = "hackathon-client"
  user_pool_id                         = aws_cognito_user_pool.hackathon_admin_pool.id
  generate_secret                      = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  explicit_auth_flows                  = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
  prevent_user_existence_errors        = "ENABLED"
  callback_urls                        = ["https://localhost/"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user" "admin_user" {
  user_pool_id = aws_cognito_user_pool.hackathon_admin_pool.id
  username     = "admin@email.com"
  attributes = {
    email = "admin@email.com"
  }
  password   = var.cognito_password_temp
  depends_on = [aws_cognito_user_pool.hackathon_admin_pool]
}

resource "aws_cognito_user_group" "gp_administradores" {
  user_pool_id = aws_cognito_user_pool.hackathon_admin_pool.id
  name         = "Administrador"
}

resource "aws_cognito_user_in_group" "add_user_in_group_adm" {
  user_pool_id = aws_cognito_user_pool.hackathon_admin_pool.id
  group_name   = aws_cognito_user_group.gp_administradores.name
  username     = aws_cognito_user.admin_user.username
}



output "cognito_client_id" {
  value     = aws_cognito_user_pool_client.hackathon_client.id
  sensitive = true
}

output "cognito_client_secret" {
  value     = aws_cognito_user_pool_client.hackathon_client.client_secret
  sensitive = true
}


output "cognito_user_pool_id" {
  value     = aws_cognito_user_pool.hackathon_admin_pool.id
  sensitive = true
}



