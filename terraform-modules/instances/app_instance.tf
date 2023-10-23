resource "aws_instance" "app_instance" {

  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnets_id[0]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = "key"
  tags                   = { Name = "app_instance" }
  user_data              = <<-EOF
    #!/bin/bash

    sudo apt update -y
    sudo apt install apache2 -y

    EOF

}
