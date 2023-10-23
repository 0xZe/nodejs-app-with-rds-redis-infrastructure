#outputs.tf
output "RDS_endpoint" {
  value = module.rds-redis.RDS_endpoint
}
output "load_balancer_dns" {
  value = module.load-balancer.load_balancer_dns

}