resource "aws_sqs_queue" "files_to_process_queue_fifo" {
  name                       = "files-to-process-queue.fifo"
  fifo_queue                 = true
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  max_message_size           = 262144
  receive_wait_time_seconds  = 20
}

resource "aws_sqs_queue" "failure_queue" {
  name                       = "failure-message-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  max_message_size           = 262144
  receive_wait_time_seconds  = 20
}

resource "aws_sqs_queue" "files-to-upload-queue" {
  name                       = "files-to-upload-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  max_message_size           = 262144
  receive_wait_time_seconds  = 20
}




