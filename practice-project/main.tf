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
    egress_only_gateway_id = aws_internet_gateway.gateway1.id
  }

  tags = {
    Name = "prod-r-table"
  }
}

# 4. create a subnet

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.main-vpc.id

  cidr_block = "10.0.0.0/24"

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

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



# 7. create a network interface with an ip in the subnet htat was created in step 4
# 8. assign an elastic ip to the network interace created in step 7
# 9. create ubuntu server and install/enable apache2

#1:26:15n nwattuwe