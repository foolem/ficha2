# Dockerfile
FROM seapy/rails-nginx-unicorn-pro:v1.1-ruby2.3.0-nginx1.8.1
MAINTAINER seapy(iamseapy@gmail.com)

# Add here your preinstall lib(e.g. imagemagick, mysql lib, pg lib, ssh config)
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install mariadb-server mariadb-client libmysqlclient-dev -y

#(required) Install Rails App
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test
ADD . /app

#(required) nginx port number
EXPOSE 80
EXPOSE 443
