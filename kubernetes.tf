resource "kubernetes_service" "hackaton_notifier_service_lb" {
  metadata {
    name      = "hackaton-notifier-service"
    namespace = var.kubernetes_namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" : "nlb",
      "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internal",
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" : "true"
    }
  }
  spec {
    selector = {
      app = "hackaton-notifier-deployment"
    }
    port {
      port        = 80
      target_port = 3001
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "hackaton_file_processor_service_lb" {
  metadata {
    name      = "hackaton-file-processor-service"
    namespace = var.kubernetes_namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" : "nlb",
      "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internal",
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" : "true"
    }
  }
  spec {
    selector = {
      app = "hackaton-file-processor-deployment"
    }
    port {
      port        = 80
      target_port = 3002
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "hackaton_file_manager_service_lb" {
  metadata {
    name      = "hackaton-file-manager-service"
    namespace = var.kubernetes_namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" : "nlb",
      "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internal",
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" : "true"
    }
  }
  spec {
    selector = {
      app = "hackaton-file-manager-deployment"
    }
    port {
      port        = 80
      target_port = 3003
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress_v1" "api_ingress" {
  metadata {
    name      = "ingress-api"
    namespace = var.kubernetes_namespace
  }

  spec {
    rule {
      http {
        path {
          path      = "/file-manager"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.hackaton_file_manager_service_lb.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
        path {
          path      = "/file-processor"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.hackaton_file_processor_service_lb.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
        path {
          path      = "/notifier"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.hackaton_notifier_service_lb.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

}

data "kubernetes_service" "file_manager_service" {
  metadata {
    name      = kubernetes_service.hackaton_file_manager_service_lb.metadata[0].name
    namespace = kubernetes_service.hackaton_file_manager_service_lb.metadata[0].namespace
  }
}

data "kubernetes_service" "file_processor_service" {
  metadata {
    name      = kubernetes_service.hackaton_file_processor_service_lb.metadata[0].name
    namespace = kubernetes_service.hackaton_file_processor_service_lb.metadata[0].namespace
  }
}

data "kubernetes_service" "notifier_service" {
  metadata {
    name      = kubernetes_service.hackaton_notifier_service_lb.metadata[0].name
    namespace = kubernetes_service.hackaton_notifier_service_lb.metadata[0].namespace
  }
}

resource "kubernetes_config_map" "hackaton_general_settings" {
  metadata {
    name      = "hackaton-general-settings"
    namespace = var.kubernetes_namespace
  }

  data = {
    AWS_REGION                     = var.aws_region
    AWS_S3_BUCKET                  = var.aws_s3_bucket
    REDIS_HOST                     = var.redis_host
    REDIS_PORT                     = var.redis_port
    SQS_FILES_TO_PROCESS_URL       = var.sqs_files_to_process_url
    SQS_QUEUE_URL                  = var.sqs_queue_url
    AWS_S3_INPUT_BUCKET            = var.aws_s3_bucket
    AWS_S3_OUTPUT_BUCKET           = var.aws_s3_bucket
    FILES_TO_PROCESS_QUEUE_URL     = var.sqs_files_to_process_url
    SQS_NOTIFICATION_QUEUE_URL     = var.sqs_notification_queue_url
    SQS_ERROR_QUEUE_URL            = var.sqs_notification_queue_url
    AWS_SQS_NOTIFICATION_QUEUE_URL = var.sqs_notification_queue_url

  }
}

resource "kubernetes_secret" "hackaton_secrets" {
  metadata {
    name      = "hackaton-secrets"
    namespace = var.kubernetes_namespace
  }

  data = {
    MAILTRAP_HOST         = var.mailtrap_host
    MAILTRAP_PORT         = var.mailtrap_port
    MAILTRAP_PASS         = var.mailtrap_pass
    MAILTRAP_USER         = var.mailtrap_user
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
    AWS_SESSION_TOKEN     = var.aws_session_token
    SESSION_TOKEN         = var.aws_session_token
    DB_HOST               = var.db_host
    DB_PORT               = var.db_port
    DB_USERNAME           = var.db_username
    DB_PASSWORD           = var.db_password
    DB_DATABASE           = var.db_database

  }

  type = "Opaque"
}

