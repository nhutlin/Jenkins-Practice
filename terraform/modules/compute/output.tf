output "instance_ip_address_public" {
  value = aws_eip.eip_lab5.public_ip
  
}

output "instance_ip_address_private" {
  value = aws_instance.instance_lab5.private_ip  # Dùng for_each trong output
}