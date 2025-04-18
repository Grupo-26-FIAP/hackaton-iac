resource "aws_apigatewayv2_api" "http_api" {
  name          = "hackathon_http_api"
  protocol_type = "HTTP"
  description   = "hackathon HTTP API"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

  lifecycle {
    prevent_destroy = false
  }
}


data "aws_lb" "order_service_lb" {
  tags = {
    "kubernetes.io/service-name" = "default/order-service"
  }

  depends_on = [kubernetes_service.order_service_lb]
}

data "aws_lb_listener" "order_service_lb_listener" {
  load_balancer_arn = data.aws_lb.order_service_lb.arn
  port              = 80

  depends_on = [kubernetes_service.order_service_lb]
}
resource "aws_apigatewayv2_route" "order_route" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "ANY /order/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lb_orders_integration.id}"

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [aws_apigatewayv2_integration.lb_orders_integration]
}

resource "aws_apigatewayv2_integration" "lb_orders_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = data.aws_lb_listener.order_service_lb_listener.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [kubernetes_service.order_service_lb]
}


data "aws_lb" "product_catalog_service_lb" {
  tags = {
    "kubernetes.io/service-name" = "default/product-catalog-service"
  }

  depends_on = [kubernetes_service.product_catalog_service_lb]
}

data "aws_lb_listener" "product_catalog_service_lb_listener" {
  load_balancer_arn = data.aws_lb.product_catalog_service_lb.arn
  port              = 80

  depends_on = [kubernetes_service.product_catalog_service_lb]
}
resource "aws_apigatewayv2_route" "product_get_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /product/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lb_products_integration.id}"

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [aws_apigatewayv2_integration.lb_products_integration]
}

resource "aws_apigatewayv2_route" "product_post_route" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "POST /product/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lb_products_integration.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.lambda_authorizer.id

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [aws_apigatewayv2_integration.lb_products_integration]
}

resource "aws_apigatewayv2_route" "product_put_route" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "PUT /product/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lb_products_integration.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.lambda_authorizer.id

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [aws_apigatewayv2_integration.lb_products_integration]
}

resource "aws_apigatewayv2_route" "product_delete_route" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "DELETE /product/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lb_products_integration.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.lambda_authorizer.id

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [aws_apigatewayv2_integration.lb_products_integration]
}

resource "aws_apigatewayv2_integration" "lb_products_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = data.aws_lb_listener.product_catalog_service_lb_listener.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [kubernetes_service.product_catalog_service_lb]
}
data "aws_lb" "payment_service_lb" {
  tags = {
    "kubernetes.io/service-name" = "default/payment-service"
  }

  depends_on = [kubernetes_service.payment_service_lb]
}

data "aws_lb_listener" "payment_service_lb_listener" {
  load_balancer_arn = data.aws_lb.payment_service_lb.arn
  port              = 80

  depends_on = [kubernetes_service.payment_service_lb]
}
resource "aws_apigatewayv2_route" "payment_route" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "ANY /payment/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lb_payment_integration.id}"

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [aws_apigatewayv2_integration.lb_payment_integration]
}

resource "aws_apigatewayv2_integration" "lb_payment_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = data.aws_lb_listener.payment_service_lb_listener.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [kubernetes_service.payment_service_lb]
}


data "aws_lb" "production_service_lb" {
  tags = {
    "kubernetes.io/service-name" = "default/production-service"
  }

  depends_on = [kubernetes_service.production_service_lb]
}

data "aws_lb_listener" "production_service_lb_listener" {
  load_balancer_arn = data.aws_lb.production_service_lb.arn
  port              = 80

  depends_on = [kubernetes_service.production_service_lb]
}
resource "aws_apigatewayv2_route" "production_get_route" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "GET /production/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lb_production_integration.id}"

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [aws_apigatewayv2_integration.lb_production_integration]
}

resource "aws_apigatewayv2_route" "production_put_route" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "PUT /production/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lb_production_integration.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.lambda_authorizer.id

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [aws_apigatewayv2_integration.lb_production_integration]
}




resource "aws_apigatewayv2_integration" "lb_production_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = data.aws_lb_listener.production_service_lb_listener.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [kubernetes_service.production_service_lb]
}


resource "aws_apigatewayv2_integration" "signin_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.signIn.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "signin_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /identify"

  target = "integrations/${aws_apigatewayv2_integration.signin_integration.id}"
}

resource "aws_lambda_permission" "allow_apigateway_signin" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signIn.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "signup_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.signUp.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "signup_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /signup"

  target = "integrations/${aws_apigatewayv2_integration.signup_integration.id}"
}

resource "aws_lambda_permission" "allow_apigateway_signup" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signUp.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "administrative_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.administrative.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "administrative_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /administrative"

  target = "integrations/${aws_apigatewayv2_integration.administrative_integration.id }"
}

resource "aws_apigatewayv2_authorizer" "lambda_authorizer" {
  api_id = aws_apigatewayv2_api.http_api.id
  name   = "lambda_authorizer"
  authorizer_type = "REQUEST"
  authorizer_uri  = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.authorizer.arn}/invocations"
  identity_sources = ["$request.header.authorization"]
  authorizer_payload_format_version = "2.0"
}

resource "aws_lambda_permission" "allow_apigateway_authorizer" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_apigateway_administrative" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.administrative.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name = "hackathon_vpc_link"
  subnet_ids = [
    aws_subnet.hackathon_private_subnet_1.id,
    aws_subnet.hackathon_private_subnet_2.id
  ]
  security_group_ids = [
    aws_security_group.api_gw_sg.id,
    aws_security_group.eks_security_group.id,
  ]

  lifecycle {
    prevent_destroy = false
  }
}


resource "aws_security_group" "api_gw_sg" {
  name        = "api-gw-sg"
  description = "Allow API Gateway access"
  vpc_id      = aws_vpc.hackathon_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

