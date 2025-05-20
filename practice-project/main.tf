provider "aws" {
  region = "eu-north-1"
  access_key = ""
  secret_key = ""
}

# What this projet does:

# 1. Create vpc

resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="main-vpc"
  }
}

# 2. Create internet gateway

resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "gw-1"
  }
}


# 3. Create custom route table

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  #mekn krnne hama ip address ekkma gateway ekt yawanawa kiyna ekai
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }

  tags = {
    Name = "prod-r-table"
  }
}

# 4. create a subnet

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "Subnet - 1 with 24 subnet masks"
  }
}

# 5. associate subnet with route tables(route table association)

resource "aws_route_table_association" "association-1" {

  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6. create sucurity group to allow port 22, 80, 443

resource "aws_security_group" "securityGP-1" {

  name = "allow_web_traffic"
  description = "aalow web inbound traffic"
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "allow_web"
  }

#   ingress = {

#   }

#   egress = {

#   }   tutoril eke kil dunne ingress and egress me wage daala eka athule ena set eka define krgena ynna , namuth aluthin thyna terraform version wala (2025 di ingress and egress use krnne nha)
}

resource "aws_vpc_security_group_ingress_rule" "https" {
    security_group_id = aws_security_group.securityGP-1.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443
}

resource "aws_vpc_security_group_ingress_rule" "http" {
    security_group_id = aws_security_group.securityGP-1.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
    security_group_id = aws_security_group.securityGP-1.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    ip_protocol = "tcp"
    to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "express-backend" {
    security_group_id = aws_security_group.securityGP-1.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 5002
    ip_protocol = "tcp"
    to_port = 5002
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.securityGP-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.securityGP-1.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# 7. create a network interface with an ip in the subnet htat was created in step 4

# resource "aws_network_interface" "web-server-netwrok-interface" {
#   subnet_id       = aws_subnet.subnet-1.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.securityGP-1.id]
# }


# 8. assign an elastic ip to the network interace created in step 7 (elastic ip)
#Note: instance argument in aws_eip is the easiest way to associate an Elastic IP directly with the EC2's primary network interface.
resource "aws_eip" "one" {
  domain                    = "vpc"
  #network_interface         = aws_network_interface.multi-ip.id
  instance = aws_instance.ubuntu-server.id  #mthna krla thiynne aluthinma network interface ekk hdnne nathuwa thiyna ec2 instance eke automaticaly aws eknma ena network interface eka use krna eki
  # associate_with_private_ip = "10.0.0.10"
  depends_on = [ aws_internet_gateway.gateway1 ]
}


# 9. create ubuntu server and install/enable apache2

resource "aws_instance" "ubuntu-server" {
  ami = "ami-0c1ac8a41498c1a9c"
  instance_type = "t3.micro"
  availability_zone = "eu-north-1a" //methna availability zone ek subnet eke thiyna availability zone ekath ekkala match wenna one, nattnm wenne subnet ek wenama data center ekk host wela instance ek wenama data center ekakin host wenwa mokd aws region pick krnne randomly me wage awastha waladi 
  key_name = "main-server"
  subnet_id = aws_subnet.subnet-1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.securityGP-1.id]

  tags = {
    Name = "Clothinx-backend-Server"
  }

  #  network interface ekk one nah mokda api ec2 nstance eke ni ekam setup krpu hinda

  #me user_ddata kiynne apita ec2 instance ek athule ghnna one commands, node js application eka run krgnna thami meka krnne 
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update   

              sudo apt install -y curl git

              curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
              sudo apt-get install -y nodejs

              git clone https://github.com/indura08/ClothinX-project-Backend /home/ubuntu/clothinx-backend

              cd /home/ubuntu/clothinx-backend

              npm install

              cat <<EOF >> .env
              MONGO_URL="should be copied"
              PASS_SEC="should be copied"
              JWT_SEC="should be copied"
              STRIPE_KEY="shoudl be copied" 
              EOT

              npm install -g pm2
              pm2 start index.js --name clothinx-backend

              EOF
}

