#!/bin/bash
sudo yum update
sudo yum -y install httpd

sudo systemctl start httpd
sudo systemctl enable httpd

sudo echo "<h1>Hello World</h1>" > ./index.html
sudo cp index.html /var/www/html/.