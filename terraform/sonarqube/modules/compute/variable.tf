variable "region" {
    type = string
    default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "amis" {
  type = map(any)
  default = {
    "us-east-1": "ami-005fc0f236362e99f"
    "us-east-2": "ami-00eb69d236edcfaf8"
  }
}

variable "image_id" {
  type = string
  description = "value"
  default = "ami-005fc0f236362e99f"
}

variable "instance_type" {
  type = string
  description = "value"
}

variable "key_name" {
  type = string
  description = "name of the keypair to use for the instance"
  nullable = false
}

variable "ec2_security_group_ids" {
  type = list(string)
  nullable = false
}

variable "instance_name" {
  type = string
  nullable = false

}

variable "root_volume_size" {
  type = number
  nullable = false
}

variable "additional_volume_size" {
  type = number
  default = 0 
}

variable "associate_public_ip_address" {
  type = bool
  default = true
  
}

variable "subnet_id" {
  type = string
  default = "subnet-014bd906e44131848"
}
# Định nghĩa các instance cần tạo
variable "instances" {
  type = map(object({
    name           = string
    user_data_path = string  # Đường dẫn đến file user data riêng cho từng instance
  }))
  description = "A map of instances to create with their respective user_data paths"
}

variable "user_data" {
  type = string
}