resource "random_string" "snapshot_suffix" {
  length  = 8
  special = false
}

resource "aws_rds_cluster" "this" {
  cluster_identifier        = "${var.prefix}-${var.environment}"
  engine                    = "aurora-mysql"
  engine_mode               = "provisioned"
  database_name             = "wordpress"
  engine_version            = var.db_engine_version
  master_username           = var.db_master_username
  master_password           = var.db_master_password
  backup_retention_period   = var.db_backup_retention_days
  preferred_backup_window   = var.db_backup_window
  final_snapshot_identifier = "${var.prefix}-${var.environment}-${random_string.snapshot_suffix.result}"
  db_subnet_group_name      = aws_db_subnet_group.this.name
  vpc_security_group_ids    = [aws_security_group.db.id]
  availability_zones        = [data.aws_availability_zones.this.names[0], data.aws_availability_zones.this.names[1], data.aws_availability_zones.this.names[2]]
  tags                      = var.tags
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
