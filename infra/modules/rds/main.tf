resource "aws_db_subnet_group" "main" {
  name       = "cloudmart-rds-subnet-group"
  subnet_ids = var.data_subnet_ids
  tags       = var.common_tags
}

resource "aws_db_instance" "postgres" {
  identifier             = "cloudmart-postgres"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp2"
  storage_encrypted      = true
  kms_key_id             = var.kms_key_arn

  db_name  = "cloudmart"
  username = "cloudmart_user"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]
  multi_az               = var.environment == "prod" ? true : false
  publicly_accessible    = false

  backup_retention_period    = 1 # Reduced for Free Tier compatibility
  backup_window              = "02:00-03:00"
  maintenance_window         = "sun:04:00-sun:05:00"
  deletion_protection        = var.environment == "prod" ? true : false
  skip_final_snapshot        = var.environment == "prod" ? false : true
  final_snapshot_identifier  = "cloudmart-postgres-final-${var.environment}"

  performance_insights_enabled = false # Disabled for Free Tier compatibility
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring.arn

  tags = var.common_tags
}

resource "aws_iam_role" "rds_monitoring" {
  name = "cloudmart-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
