resource "aws_sqs_queue" "order_created_queue" {
  name                       = "order-created-queue.fifo"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  max_message_size           = 262144
  receive_wait_time_seconds  = 20
  fifo_queue = true
  content_based_deduplication = true
}

resource "aws_sqs_queue" "payment_status_updated_queue" {
  name                       = "payment-status-updated-queue.fifo"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  max_message_size           = 262144
  receive_wait_time_seconds  = 20
  fifo_queue = true
  content_based_deduplication = true
}

resource "aws_sqs_queue" "order_ready_for_production_queue" {
  name                       = "order-ready-for-production-queue.fifo"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  max_message_size           = 262144
  receive_wait_time_seconds  = 20
  fifo_queue = true
  content_based_deduplication = true
}

resource "aws_sqs_queue" "production_status_updated_queue" {
  name                       = "production-status-updated-queue.fifo"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  max_message_size           = 262144
  receive_wait_time_seconds  = 20
  fifo_queue = true
  content_based_deduplication = true
}