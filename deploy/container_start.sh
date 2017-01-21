#!/bin/sh
cd /var/projects/ehealth && python manage.py migrate --noinput
supervisord -n -c /etc/supervisor/supervisord.conf