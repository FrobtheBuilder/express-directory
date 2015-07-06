FROM phusion/baseimage
RUN apt-get -y update && apt-get install -y nodejs nodejs-legacy npm mongodb git pkg-config
RUN curl -s https://raw.githubusercontent.com/lovell/sharp/master/preinstall.sh | bash -
RUN mkdir /var/www
ADD . /var/www
RUN cd /var/www && npm install
CMD nodemon