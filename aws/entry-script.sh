#!/bin/bash
sudo yum update && sudo yum -y install httpd
sudo systemctl start httpd && sudo systemctl enable httpd

sudo yum -y install docker
sudo systemctl start docker

sudo usermod -aG docker ec2-usermod
sudo docker container run -d -p 8080:80 nginx