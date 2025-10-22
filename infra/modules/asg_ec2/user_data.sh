#!/bin/bash
set -euxo pipefail

dnf -y update
dnf -y install nginx

mkdir -p /usr/share/nginx/html
echo "Hello from mini-prod (hoooo2025)" > /usr/share/nginx/html/index.html

systemctl enable nginx
systemctl restart nginx