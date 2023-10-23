resource "aws_security_group" "lb_sg" {
  name        = "Allow 80 from any"
  description = "Allow 80 inbound traffic from any"
  vpc_id      = var.appvpc_id


  ingress {
    description = "80 from any(to receive requests from anywhere)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
