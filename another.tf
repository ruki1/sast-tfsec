provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami = data.aws_ami.RHEL.id

}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_autoscaling_group" "my_asg" {
  availability_zones        = ["us-east-1a"]
  name                      = "my_asg"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  launch_configuration      = "my_web_config"
}

resource "aws_launch_configuration" "my_web_config" {
  name = "my_web_config"
  image_id = ami = data.aws_ami.RHEL.id
  instance_type = "t2.micro"

}

data "aws_ami" "RHEL" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["RHEL-9.2.0_HVM-*-41-Hourly2-GP2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "<your-bucket-name>"
}

