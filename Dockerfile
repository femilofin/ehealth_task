# Python 2.7 - https://github.com/docker-library/python/blob/a248f4583c5f788e1af02016f762cdc323ee5765/2.7/Dockerfile
FROM python:2.7
MAINTAINER Oluwafemi Olofintuyi

# Get noninteractive frontend for Debian to avoid some problems:
# debconf: unable to initialize frontend: Dialog
ENV DEBIAN_FRONTEND noninteractive

# Update packages and OS
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y
RUN apt-get install -y apt-utils

# Install Python Setuptools and some other fancy tools for working with this container if we choose to attach to it
RUN apt-get install -y tar git curl nano wget dialog net-tools build-essential
RUN apt-get install -y python python-dev python-distribute python-pip

# setup startup script for gunicord WSGI service
RUN groupadd webapps
RUN useradd webapp -G webapps
RUN mkdir -p /var/log/webapp/ && chown -R webapp /var/log/webapp/ && chmod -R u+rX /var/log/webapp/
RUN mkdir -p /var/run/webapp/ && chown -R webapp /var/run/webapp/ && chmod -R u+rX /var/run/webapp/

# install and configure supervisord
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD ./deploy/supervisor_conf.d/webapp.conf /etc/supervisor/conf.d/webapp.conf


# copy the contents of this directory over to the container at location /src
ADD . /var/projects/ehealth

# set the working directory
WORKDIR /var/projects/ehealth

# install requirements
RUN pip install -r requirements.txt

# run container_start.sh when container starts
CMD ["sh", "./deploy/container_start.sh"]

# Expose listening ports
EXPOSE  8002