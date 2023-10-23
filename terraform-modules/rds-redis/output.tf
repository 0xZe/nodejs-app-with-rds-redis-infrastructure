#outputs.tf
output "RDS_endpoint" {
  value = aws_db_instance.myinstance.endpoint
}