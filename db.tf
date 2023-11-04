resource "random_string" "snapshot_suffix" {
  length  = 8
  special = false
}

resource "aws_rds_cluster" "this" {
  cluster_identifier        = "${var.prefix}-${var.environment}"
  database_name             = "wordpress"
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.04.0"
  enable_http_endpoint      = false
  master_username           = var.db_master_username
  master_password           = var.db_master_password
  backup_retention_period   = var.db_backup_retention_days
  preferred_backup_window   = var.db_backup_window
  storage_encrypted         = true
  enabled_cloudwatch_logs_exports = ["audit"]

  serverlessv2_scaling_configuration {
    min_capacity = 1
    max_capacity = 2
  }

  db_subnet_group_name      = aws_db_subnet_group.this.name
  vpc_security_group_ids    = [aws_security_group.db.id]
  availability_zones        = [data.aws_availability_zones.this.names[0], data.aws_availability_zones.this.names[1], data.aws_availability_zones.this.names[2]]
  tags                      = var.tags

  skip_final_snapshot  = true
  apply_immediately = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  engine                        = "aurora-mysql"
  engine_version                = "8.0.mysql_aurora.3.04.0"
  cluster_identifier            = "${var.prefix}-${var.environment}"
  instance_class                = "db.serverless"

  # Enhanced monitoring
  monitoring_interval = 30
  monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
}

################################################################################
# Create an IAM role to allow enhanced monitoring
################################################################################

resource "aws_iam_role" "rds_enhanced_monitoring" {
  name_prefix        = "rds-enhanced-monitoring-"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.prefix}-${var.environment}"
  subnet_ids = module.vpc.private_subnets
  tags       = var.tags
}

resource "aws_security_group" "db" {
  vpc_id = module.vpc.vpc_id
  name   = "${var.prefix}-db-${var.environment}"
  ingress {
    protocol  = "tcp"
    from_port = 3306
    to_port   = 3306
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "aws_ssm_parameter" "db_master_user" {
  name  = "/${var.prefix}/${var.environment}/db_master_user"
  type  = "SecureString"
  value = var.db_master_username
  tags  = var.tags
}

resource "aws_ssm_parameter" "db_master_password" {
  name  = "/${var.prefix}/${var.environment}/db_master_password"
  type  = "SecureString"
  value = var.db_master_password
  tags  = var.tags
}
