#!/bin/sh
cd /var/projects/ehealth && python manage.py migrate --noinput
supervisord -n -c /etc/supervisor/supervisord.conf

# start the containers
docker-compose build
docker-compose up -d

# bind port 80 in the container to port 80 on nginx
docker run -d -p 80:80 -p 443:443 nginx:latest