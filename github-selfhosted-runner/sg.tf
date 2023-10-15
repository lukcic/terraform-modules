resource "aws_security_group" "branches" {
  name_prefix = "${var.project_id}-${var.environment}-sg"
  description = "GitHub self hosted runner security group"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress" {
  description       = "Egress to all."
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.branches.id
}

resource "aws_security_group_rule" "ssh" {
  for_each          = var.branches_config
  description       = "Inboud SSH from ${each.value.name}"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = [each.value.ip]
  security_group_id = aws_security_group.branches.id
}

resource "aws_security_group_rule" "metrics" {
  description       = "Inboud 9100 from ${var.prometheus_host}"
  type              = "ingress"
  from_port         = "9100"
  to_port           = "9100"
  protocol          = "tcp"
  cidr_blocks       = [var.prometheus_host]
  security_group_id = aws_security_group.branches.id
}