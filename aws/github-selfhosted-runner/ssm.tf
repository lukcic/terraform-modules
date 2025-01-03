resource "aws_iam_instance_profile" "instance-profile" {
  name_prefix = "${var.project_id}-${var.environment}-gh-shrunner-profile"
  role = aws_iam_role.instance-role.name
}

resource "aws_iam_role" "instance-role" {
  name_prefix = "${var.project_id}-${var.environment}-gh-shrunner-role"
  description = "Role for the GH self hosted runner instance"
  managed_policy_arns = [ 
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
   ]
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