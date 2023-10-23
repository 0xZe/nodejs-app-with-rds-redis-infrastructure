#outputs.tf
output "RDS_endpoint" {
  value = module.db.RDS_endpoint
}
output "load_balancer_dns" {
  value = module.load-balancer.load_balancer_dns

}