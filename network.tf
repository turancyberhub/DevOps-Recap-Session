# Scenario:
# 1. We have VPC created manually  and we need to use that VPC instead of creating a new one
# 2. Create 2 subnets based of above manually created VPCs
# 3. Create internet gateway based of above VPC

# resource "aws_vpc" "class_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "my_vpc1"
#   }
# }

data "aws_vpc" "turancyberhub_vpc" {
  id = "vpc-032be006a4af7b363"
}

resource "aws_subnet" "subnet1" {
  vpc_id = data.aws_vpc.turancyberhub_vpc.id
  cidr_block = "10.0.5.0/24" #10.0.0.0-255  #10.0.0.143
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = data.aws_vpc.turancyberhub_vpc.id
  cidr_block = "10.0.6.0/24"  #10.0.1.0-255
  tags = {
    Name = "subnet2"
  }
}

# resource "aws_internet_gateway" "my_gateway" {
#   vpc_id = data.aws_vpc.turancyberhub_vpc.id
#   tags = {
#     Name = "ig3"
#   }
# }

output "vpc_range" {
    value = data.aws_vpc.turancyberhub_vpc.cidr_block
}

output "vpc_name" {
    value = data.aws_vpc.turancyberhub_vpc.tags
}


# data source to pull aws ami id 
data "aws_ami" "amazon-linux-2" {
 most_recent = true

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}


resource "aws_instance" "tf_instance" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  tags = {
    Name = "data_source_example"
  }
}
