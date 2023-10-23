#create redis subnet group
resource "aws_elasticache_subnet_group" "elasticache-subnet-group" {
  name       = "elasticache-subnet-group"
  subnet_ids = [var.private_subnets_id[0], var.private_subnets_id[1]]
}

#create redis parms
resource "aws_elasticache_parameter_group" "redis-params" {
  name   = "redis-params"
  family = "redis7"

}

#create redis cluster
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "redis-params"
  subnet_group_name    = "elasticache-subnet-group"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis_sg.id]
  depends_on           = [aws_elasticache_subnet_group.elasticache-subnet-group]
}

