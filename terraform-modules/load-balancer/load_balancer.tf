#target_group
resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = "3000"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.appvpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    interval            = 10
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
  }
}

#Attach private ec2 to the target group
resource "aws_lb_target_group_attachment" "aws_lb_target_group_attachment" {

  count            = 1
  target_id        = var.app-instance_id
  target_group_arn = aws_lb_target_group.target_group.arn
  port             = "3000"

}

#load balancer
resource "aws_lb" "load_balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [var.public_subnets_id[0], var.public_subnets_id[1]]
}

#load balancer listener 
resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.target_group.arn
      }
    }
  }
}


