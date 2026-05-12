resource "aws_security_group" "threatmod_application_load_balancer_sg" {
    name_prefix = "alb-"
    vpc_id      = var.vpc_id
    description = "Security group for the Application Load Balancer"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP from anywhere"
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS from anywhere"
    }

    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        ipv6_cidr_blocks = ["::/0"]
        description      = "HTTP from anywhere (IPv6)"
    }

    ingress {
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        ipv6_cidr_blocks = ["::/0"]
        description      = "HTTPS from anywhere (IPv6)"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle { create_before_destroy = true }

    tags = { Name = "threatmod-application-load-balancer-sg", Environment = var.environment }
}

resource "aws_lb" "threatmod_application_load_balancer" {
    name                           = "threatmod-alb"
    internal                       = false
    load_balancer_type             = "application"
    security_groups                = [aws_security_group.threatmod_application_load_balancer_sg.id]
    subnets                        = var.public_subnet_ids
    enable_deletion_protection     = false

    tags = { Name = "threatmod-application-load-balancer-main", Environment = var.environment }
}

resource "aws_lb_target_group" "threatmod_target_group" {
    name        = "threatmod-target-group"
    port        = var.container_port
    protocol    = "HTTP"
    vpc_id      = var.vpc_id
    target_type = "ip"

    health_check {
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

    tags = { Name = "threatmod-target-group", Environment = var.environment }
}

resource "aws_lb_listener" "threatmod_alb_listener_https" {
    load_balancer_arn = aws_lb.threatmod_application_load_balancer.arn
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    certificate_arn   = var.certificate_arn

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.threatmod_target_group.arn
    }

    tags = { Name = "threatmod-alb-listener-https", Environment = var.environment }
}

resource "aws_lb_listener" "threatmod_alb_listener_for_redirect_http_to_https" {
    load_balancer_arn = aws_lb.threatmod_application_load_balancer.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type = "redirect"
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }

    tags = { Name = "threatmod-alb-listener-redirect-to-https", Environment = var.environment }
}
