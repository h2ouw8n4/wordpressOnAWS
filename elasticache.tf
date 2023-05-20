resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.prefix}-elasticache-${var.environment}"
  subnet_ids = module.vpc.private_subnets
  tags       = var.tags
}

resource "aws_security_group" "elasticache" {
  vpc_id = module.vpc.vpc_id
  name   = "${var.prefix}-elasticache-${var.environment}"
  ingress {
    protocol  = "tcp"
    from_port = 11211
    to_port   = 11211
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_cluster" "this" {
  cluster_id           = "${var.prefix}-elasticache-cluster-${var.environment}"
  engine               = "memcached"
  engine_version       = "1.6.6"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  security_group_ids   = [aws_security_group.elasticache.id]
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  tags                 = var.tags
}
