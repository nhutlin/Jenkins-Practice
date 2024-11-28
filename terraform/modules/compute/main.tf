resource "aws_instance" "instance_lab5" {
    ami = var.image_id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = var.ec2_security_group_ids
    tags = {
        Name: var.instance_name
    }
    root_block_device {
        volume_size = var.root_volume_size 
        volume_type = "gp2"               
    }


    associate_public_ip_address = var.associate_public_ip_address
    subnet_id = var.subnet_id
    user_data = var.user_data
  
}
resource "aws_eip" "eip_lab5" {
  instance = aws_instance.instance_lab5.id 
}
