resource "aws_security_group" "app_sg" {
  name        = "Allow ssh_3000 from vpc cidr"
  description = "Allow ssh_3000 inbound traffic from vpc cidr"
  vpc_id      = var.appvpc_id


  ingress {
    description = "SSH from vpc(10.0.0.0/16)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]


  }

  ingress {
    description = "3000 from load balancer(to expose application)"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

  }

  ingress {
    description = "80 from load balancer (for healthy check)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


}