provider "aws" {
  version = "4.63.0"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "veeam-test-bucket-12345"
    key    = "tch/terraform/ec2/myinstance.tfstate"
    region = "us-east-1"
    dynamodb_table = "tch-lock-table"
  }
}

resource "aws_instance" "apache" {
  ami           = var.instance_ami_id["us-east-1"]
  instance_type = var.instance_type[0]
  tags = {
    "Name"    = "terraform_instance"
    "Purpose" = "learning_tf"
    "Owner"   = "VakhobAvazov"
  }
}

variable "instance_ami_id" {
  type = map
  # default = {
  #   # Identifier       =     Value
  #   "us-east-1"          = "ami-0889a44b331db0194"
  #   "us-east-2"          = "ami-08333bccc35d71140"
  #   "us-west-1"          = "ami-051ed863837a0b1b6"
  #   "us-west-2"          = "ami-04e914639d0cca79a"
  # }
}

# First Name                                 Last Name
# Dilshod                                     Saidmurodova
# Coskun                                      Avazov
# Vakhob                                      Karabiyik
# Dinara                                      Aripov

variable "instance_type" {
  type = list
  #default = ["t2.micro", "t2.nano", "t2.large", "t2.medium"]
#positionNo    [0]          [1]         [2]         [3]  ...
}

resource "aws_instance" "manual" {
  #count = 3
  ami           = var.instance_ami_id["us-east-1"]
  instance_type = var.instance_type[2]
  subnet_id = aws_subnet.subnet_1.id
  tags = {
    "Name"    = "manual_instance"
  }
}

resource "aws_instance" "manual1" {
  ami           = var.instance_ami_id["us-east-1"]
  instance_type = var.instance_type[1]
  subnet_id = aws_subnet.subnet_1.id
  tags = {
    "Name"    = "manual_instance1"
  }
}

resource "aws_eip" "my_first_eip" {
  instance = aws_instance.manual.id
  tags = {
    Name = "my_eip"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf_vpc_example"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "tf_example"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.example.id
}

output "manual_instance_public_ip" {
  #value = <resource_type>.<resource_name>.<attribute> #FORMULA
  value = aws_instance.manual.public_ip
}

output "my_name" {
  value = "Vakhob"
}
