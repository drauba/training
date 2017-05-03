#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-2df66d3b
#
# Your subnet ID is:
#
#     subnet-75a08610
#
# Your security group ID is:
#
#     sg-4cc10432
#
# Your Identity is:
#
#     testing-walrus
#

terraform {
  backend "atlas" {
    name = "drauba/training"
  }
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

resource "aws_instance" "web" {
  count                  = "2"
  instance_type          = "t2.micro"
  ami                    = "ami-2df66d3b"
  subnet_id              = "subnet-75a08610"
  vpc_security_group_ids = ["sg-4cc10432"]

  tags {
    Identity = "testing-walrus"
    Name     = "${format("web %1d / 2 ", count.index+1) }"
    Testing  = "true"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
