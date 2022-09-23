output "ec2_public_ip" {
  description = "Public IP address of the instance"
  value = aws_instance.my_vm[count.index].public_ip
}

output "vpc_id" {
  description = "ID address of the VPC"
  value = aws_vpc.my_vpc.id
}

output "ami_id" {
  description = "ID of AMI"
  value = aws_instance.my_vm[count.index].ami
  sensitive = true
}

# terraform output -json

output "datetime" {
  value =local.time
}