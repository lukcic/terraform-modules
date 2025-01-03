data "aws_ami" "ubuntu" {
    owners = ["099720109477"] # Canonical
    most_recent = true

    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    
    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }
}

resource "aws_instance" "runner-instance" {
  ami                   = var.ami != null ? var.ami.id : data.aws_ami.ubuntu.id
  iam_instance_profile  = aws_iam_instance_profile.instance-profile.name
  security_groups       = [aws_security_group.branches.id]
  key_name              = var.key_pair_name
  subnet_id             = var.subnet_id
  instance_type         = "t3.large"
  
  lifecycle {
    create_before_destroy = true
  }
  
  root_block_device {
    volume_type = "gp3"
    volume_size = 250
  }

  user_data_replace_on_change = true
  
  user_data = templatefile("${path.module}/userdata.tftpl", {
    node_ver          = var.node_ver
    runner_ver        = var.runner_ver
    runner_name       = var.runner_name
    runner_token      = var.runner_token
    github_repo_url   = var.github_repo_url
    images_age        = var.images_age
    exporter_version  = var.exporter_version
  })
  
  tags = {
    Name        = "${var.project_id}-${var.environment}-github-selfhosted-runner"
    Environment = "${var.environment}"
    Schedule    = var.schedule_name
  }
}