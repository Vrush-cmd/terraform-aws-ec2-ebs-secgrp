provider "aws" {
  region  = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_key_pair" "kp1" {
  key_name   = "key1"
  public_key = var.pubkey
}

resource "aws_security_group" "my_firewall" {

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }

  tags = {
    Name = "sgf"
  }
}

resource "aws_instance" "task6" {
  ami           = var.ami
  instance_type = var.mtype
  key_name = aws_key_pair.kp1.key_name
  security_groups= ["${aws_security_group.my_firewall.name}"]
  tags= {
    Name = "VRUSH"
  }
}

resource "aws_ebs_volume" "st1" {
 availability_zone = aws_instance.task6.availability_zone
 size = 1
 tags= {
    Name = "My volume"
  }
}

resource "aws_volume_attachment" "ebs" {
 device_name = "/dev/sdh"
 volume_id = aws_ebs_volume.st1.id
 instance_id = aws_instance.task6.id 
}
