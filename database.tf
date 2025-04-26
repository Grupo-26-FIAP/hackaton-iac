resource "aws_db_instance" "video_processor_db" {
  identifier               = "video-processor"
  allocated_storage        = 20
  max_allocated_storage    = 100
  engine                   = "postgres"
  engine_version           = "16.3"
  instance_class           = "db.t4g.micro"
  username                 = var.postgres_user
  password                 = var.postgres_password
  parameter_group_name     = "default.postgres16"
  skip_final_snapshot      = true
  publicly_accessible      = true
  backup_retention_period  = 7
  delete_automated_backups = true

  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  tags = {
    Name = "video-processor-rds"
  }
}


resource "aws_security_group" "database_security_group" {
  name_prefix = "rds-sg-"
  description = "Allow database access"

  ingress {
    description = "Allow access from ECS tasks"
    from_port   = 5432
    to_port     = 5432
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