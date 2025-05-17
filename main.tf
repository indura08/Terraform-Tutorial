//first thing is - define a provider

provider "aws" {
  region = "us-east-1"

  //me secret_key and access_key aws profile eke security credentials hdnna one , eta passe wenama scret key ekkui access key ekkui hdgnna one , e hdgnna deka thami methnat daanne 
  // samnyen me security keyand access keys public version controller systme walt daddi security patten hithla noda inna one, me widiyt me script eke liyl thiynwa wage danne nha github ekt.
  access_key = "thisShouldBeTheAccessKey"
  secret_key = "thisSHouldBethesecrteKey"

}

//eta passe part eka thami provisionning part ek - meka theruma attama provider ek athule resources hdna eki 
# resource "providerName" "name" {
#   //config options
# } me thami resource ekk liyna structure ek 

resource "aws_instance" "web" {
  //configoptions
  ami           = amiekamehmdanwaVariableEkkWidiytDanawaNmHodi
  instance_type = "t3.micro"

  tags = {
    Name = "Hellow world"
  }
  
}
