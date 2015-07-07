FROM phusion/baseimage
RUN mkdir -p /data/db
RUN apt-get -y update && apt-get install -y nodejs nodejs-legacy npm mongodb git pkg-config supervisor
RUN curl -s https://raw.githubusercontent.com/lovell/sharp/master/preinstall.sh | bash -
RUN mkdir /var/www
ADD . /var/www
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN cd /var/www && npm install && npm install -g nodemon coffee-script
RUN service mongodb start
EXPOSE 27017 28017 3000
CMD ["/usr/bin/supervisord"]