resource "kubernetes_service" "order_service_lb" {
  metadata {
    name      = "order-service"
    namespace = var.kubernetes_namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" : "nlb",
      "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internal",
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" : "true"
    }
  }
  spec {
    selector = {
      app = "hackathon-order-deployment"
    }
    port {
      port        = 80
      target_port = 3001
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "product_catalog_service_lb" {
  metadata {
    name      = "product-catalog-service"
    namespace = var.kubernetes_namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" : "nlb",
      "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internal",
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" : "true"
    }
  }
  spec {
    selector = {
      app = "hackathon-product-catalog-deployment"
    }
    port {
      port        = 80
      target_port = 3002
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "payment_service_lb" {
  metadata {
    name      = "payment-service"
    namespace = var.kubernetes_namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" : "nlb",
      "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internal",
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" : "true"
    }
  }
  spec {
    selector = {
      app = "hackathon-payment-deployment"
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
          path      = "/product"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.product_catalog_service_lb.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
        path {
          path      = "/order"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.order_service_lb.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }

        path {
          path      = "/production"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.production_service_lb.metadata[0].name
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

data "kubernetes_service" "product_catalog_service" {
  metadata {
    name      = kubernetes_service.product_catalog_service_lb.metadata[0].name
    namespace = kubernetes_service.product_catalog_service_lb.metadata[0].namespace
  }
}

data "kubernetes_service" "order_service" {
  metadata {
    name      = kubernetes_service.order_service_lb.metadata[0].name
    namespace = kubernetes_service.order_service_lb.metadata[0].namespace
  }
}

data "kubernetes_service" "payment_service" {
  metadata {
    name      = kubernetes_service.payment_service_lb.metadata[0].name
    namespace = kubernetes_service.payment_service_lb.metadata[0].namespace
  }
}