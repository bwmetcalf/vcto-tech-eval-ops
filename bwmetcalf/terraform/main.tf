provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "redis" {
  name        = "redis"
  description = "Redis Security Group"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "SSH Security Group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "haproxy" {
  name        = "haproxy"
  description = "HAProxy Security Group"

  ingress {
    from_port   = 80 
    to_port     = 80 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "icmp" {
  name        = "icmp"
  description = "Ping Security Group"

   ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = "app"
  description = "APP Security Group"

  ingress {
    from_port   = 8080 
    to_port     = 8080 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_cluster" "countme" {
  cluster_id           = "countme"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  port                 = 6379
  num_cache_nodes      = 1

  subnet_group_name = "alegion"

  security_group_ids = [
    "${aws_security_group.redis.id}"
  ]
}

resource "aws_instance" "haproxy" {
  ami           = "ami-97785bed"
  instance_type = "t1.micro"
  key_name      = "bmetcalf"

  count = 1

  vpc_security_group_ids = [
    "${aws_security_group.haproxy.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.icmp.id}"
  ]

  connection {
    user = "ec2-user"
    host = "${self.public_ip}"
  }

  tags = {
    Name = "alegion_haproxy_server"
  }

#  provisioner "remote-exec" {
#    inline = [
#      "sudo yum -y update",
#      "sudo yum -y install haproxy"
#    ]
#  }
}

resource "aws_instance" "app" {
  ami           = "ami-97785bed"
  instance_type = "t1.micro"
  key_name      = "bmetcalf"

  count = 2

  vpc_security_group_ids = [
    "${aws_security_group.app.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.icmp.id}"
  ]

  connection {
    user = "ec2-user"
    host = "${self.public_ip}"
  }

  tags = {
    Name = "alegion_app_server"
  }

#  provisioner "remote-exec" {
#    inline = [
#      "sudo yum -y update",
#      "sudo yum -y install haproxy"
#    ]
#  }
}
