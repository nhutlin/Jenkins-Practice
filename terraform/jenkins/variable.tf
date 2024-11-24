variable "image_id" {
  type = string
  description = "value"
}

variable "instance_type" {
  type = string
  description = "value"
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "amis" {
  type = map(any)
  default = {
    "us-east-1": "ami-005fc0f236362e99f"
    "us-east-2": "ami-00eb69d236edcfaf8"
  }
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "keypair_path" {
  type = string
  # default = "./keypair/mykey.pub"
}


variable "instance_name" {
  type = string
}
variable "root_volume_size" {
  
}

variable "instances" {
  type = map(object({
    name           = string
    user_data_path = string
  }))
  default = {
    Jenkins-Server = {
      name           = "Jenkins-Server"
      user_data_path = "./file/install_jenkins.sh"  
    }
    Jenkins-Slave = {
      name           = "Jenkins-Slave"
      user_data_path = "./file/install_java.sh" 
    }
  description = "A map of instances to create"
  }
}