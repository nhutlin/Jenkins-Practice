terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76.0"
    }
  }
}

provider "aws" {
  region = var.region
}
resource "aws_key_pair" "lab2-keypair" {
  key_name =  "lab2-keypair"
  public_key = file(var.keypair_path)
  
}

module "security" {
  source = "../modules/security"
  region = var.region
  aws_profile = var.aws_profile
  
}

module "compute" {
  for_each = var.instances
  source = "../modules/compute"
  instances = var.instances 
  user_data = file(each.value.user_data_path)
  region = var.region
  image_id = var.image_id
  key_name = aws_key_pair.lab2-keypair.key_name
  instance_type = var.instance_type
  ec2_security_group_ids = [module.security.public_security_group_id]
  instance_name = each.value.name
  root_volume_size = var.root_volume_size
}



