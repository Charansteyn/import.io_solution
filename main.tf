resource "aws_instance" "ec2" {

  ami           = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.medium"
  key_name      = "EC2 Instance"

  vpc_security_group_ids = ["aws_security_group.ec2_sg"]
  vpc_id                 = aws_vpc.default
  tags = {
    Name = "EC2 Instance"
  }
}
data "aws_vpc" "default" {
  default = true
}
resource "aws_security_group" "ec2_sg" {
  name        = "ec2 security grp"
  description = "Define inbound and outbound rules"
  vpc_id      = aws_vpc.default

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["107.22.40.204/32", "18.215.226.36/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "MySQL"
    cidr_blocks = [aws_db_security_group.rds.id]
  }

  tags {
    Name = "Allow IPs"
  }
}
resource "aws_ebs_volume" "ebs" {
  availability_zone = "ap-south-1a"
  size              = "8"
}

resource "aws_volume_attachment" "ebs_att" {
  instance_id = aws_db_instance.ebs.id
  device_name = "/dev/sda1"
  volume_id   = aws_ebs_volume.ebs.id
}

resource "aws_db_security_group" "rds" {
  name   = "rdssg"
  vpc_id = aws_vpc.default

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = aws_security_group.ec2_sg.id
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
resource "aws_db_instance" "default" {
  identifier          = "mysql-db"
  name                = "RDS"
  allocated_storage   = "20"
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.medium"
  multi_az            = false
  publicly_accessible = true
  username            = var.username
  password            = var.password
  tags = {
    Name = "newdb"
  }
  skip_final_snapshot = true
}
    