provider "aws" {
  region = "eu-north-1"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "firt-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name : "Production Env."
    }
}

resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.firt-vpc.id        //this is what we call referencing , look here we are giving the name of above resource ("first-vpc"), and api subnet ekk hadaddi e subnet eka mona vpc ekeda kiyna eka denna one, so subnet ekt denne api loku vpc eke id eka eki meke .id kiyl anthimt thiynne 
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "production-subnet-1"
    }
  
}

//methna dewaniyat dapu resource eke api refernece ek gnnwa neh first-vpc eke ,
//so eke theruma api aniwaryenma refrence eka ganna resource ek kalin define krnna one kiyl ekk nha 