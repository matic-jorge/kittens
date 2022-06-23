data "aws_ami_ids" "amzn_linux_2" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "creation-date"
    values = [format("%s*", formatdate("YYYY", timestamp()))]
  }
  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
  sort_ascending = true
}

resource "aws_security_group" "gateway" {
  name        = "Gateway"
  description = "Allow outbound communication, ingress from selected IPs"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "gateway"
    environment = var.environment
  }
}

resource "aws_security_group_rule" "gateway_ingress_all_vpc" {
  type              = "ingress"
  description       = "All traffic from VPC"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.gateway.id
}

resource "aws_security_group_rule" "gateway_ingress_ssh" {
  type              = "ingress"
  description       = "SSH to private VPC"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.gateway.id
}

resource "aws_security_group_rule" "gateway_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.gateway.id
}

resource "aws_network_interface" "gateway" {
  for_each          = aws_subnet.gateway
  subnet_id         = each.value.id
  security_groups   = [aws_security_group.gateway.id]
  source_dest_check = false

  tags = {
    Name        = "gateway-${var.environment}"
    environment = var.environment
  }
}

resource "aws_eip" "gateway" {
  for_each          = aws_network_interface.gateway
  vpc               = true
  network_interface = each.value.id
}

resource "aws_instance" "gateway" {
  ami                  = data.aws_ami_ids.amzn_linux_2.ids[length(data.aws_ami_ids.amzn_linux_2.ids) - 1]
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.builder.name
  user_data            = <<-EOT
		#!/bin/bash
		sudo sysctl -w net.ipv4.ip_forward=1
		sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
		sudo yum install -y iptables-services
		sudo service iptables save
		EOT

  dynamic "network_interface" {
    for_each = aws_network_interface.gateway
    content {
      device_index         = network_interface.key
      network_interface_id = network_interface.value.id
    }
  }

  tags = {
    Name        = "gateway-${var.environment}"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.daily_driver
  public_key = data.local_file.daily_driver_ssh_pub_key.content
}
