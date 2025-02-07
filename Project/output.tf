output "public_ip_add" {
    value = aws_instance.main.public_ip
  
}

output "instance_state" {
    value = aws_instance.main.instance_state
  
}