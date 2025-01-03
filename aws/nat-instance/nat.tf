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

resource "aws_security_group" "security_group" {
  name = "nat_instance_security_group"
  description = "Security group for NAT instance"
  vpc_id = var.vpc_id
  
  ingress = [
    {
      description = "Ingress CIDR"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [var.vpc_cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
  
  egress = [
    {
      description = "Default egress"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
}


resource "aws_network_interface" "network_interface" {
  subnet_id = var.subnet_id
  source_dest_check = false
  security_groups = [aws_security_group.security_group.id]

  tags = {
    Name = "nat_instance_network_interface"
  }
}

resource "aws_instance" "nat_instance" {
  ami = var.nat_ami != null ? var.nat_ami.id : data.aws_ami.ubuntu.id
  instance_type = "t3.nano"
  key_name = var.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.nat-instance-resources-iam-profile.name

  user_data_replace_on_change = true
  
  user_data = templatefile("${path.module}/userdata.tftpl", {
      vpc_cidr = var.vpc_cidr
  })

  network_interface {
    network_interface_id = aws_network_interface.network_interface.id
    device_index = 0
  }
  
  tags = {
    Name = "nat_instance"
    Role = "nat"
  }
}

resource "aws_eip" "nat_eip" {
  instance = aws_instance.nat_instance.id
  tags = {
    "Name" = "nat_instance"
  }
}

resource "aws_iam_instance_profile" "nat-instance-resources-iam-profile" {
  name = "nat_instanceec2_profile"
  role = aws_iam_role.nat-instance-resources-iam-role.name
}

resource "aws_iam_role" "nat-instance-resources-iam-role" {
  name        = "nat-instance-ssm-role"
  description = "The role for the NAT instance EC2"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nat-instance-resources-ssm-policy" {
  role       = aws_iam_role.nat-instance-resources-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "nat-instance-resources-cwagent-policy" {
  role       = aws_iam_role.nat-instance-resources-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}