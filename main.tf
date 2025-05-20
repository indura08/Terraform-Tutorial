//first thing is - define a provider

provider "aws" {
  region = "eu-north-1"

  //me secret_key and access_key aws profile eke security credentials hdnna one , eta passe wenama scret key ekkui access key ekkui hdgnna one , e hdgnna deka thami methnat daanne 
  // samnyen me security keyand access keys public version controller systme walt daddi security patten hithla noda inna one, me widiyt me script eke liyl thiynwa wage danne nha github ekt.
  access_key = ""
  secret_key = ""

  //An AWS Access Key is like a username + password that your code or tools use to talk to AWS without using a browser. It's made of two parts: Access Key ID (like a username) Secret Access Key (like a password)

}

//eta passe part eka thami provisionning part ek - meka theruma attama provider ek athule resources hdna eki 
# resource "provider_NameofResourceType" "name: name means that me hdna resource ekt nikna referenece name ekk wage denwa iyna eki, nikan varibale name ekk wage" {
#   //config options
# } me thami resource ekk liyna structure ek 

resource "aws_instance" "my-frist-ec2-instance" {
  #config options 
  ami           = "ami-0c1ac8a41498c1a9c" #this is a ami for ubuntu server 24.04 LTS, ami ek gannkota region eka anuwa thami ganna one 
  instance_type = "t3.micro"

  tags = {
    Name = "ubuntu-server-made-with-terrafrom"
  }
  
}

//commands:

//  1. terraform init
//  2.terrafrom plan: this will steup what are we gonna provision and show us a output, so this is help full to see everyhting before applying it and ruining production if something has gone wrong
//  3.terraform apply: to run our script and do the provisioninig

//in yerrafrom no matter how much time we run terraform apply it is only creating 1 resouces
//api kochchr terrafrom run command ek ghuwath aluthing , nwatha nawatha resources hdenne nha , hdena ek hdeenne ak parai 
