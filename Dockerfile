FROM marcbachmann/libvips
RUN apt-get -y update && apt-get install -y nodejs nodejs-legacy npm git pkg-config
RUN curl -s https://raw.githubusercontent.com/lovell/sharp/master/preinstall.sh | bash -
RUN mkdir /var/www
ADD . /var/www
RUN cd /var/www && npm install && npm install -g nodemon coffee-script
EXPOSE 3000
WORKDIR "/var/www"
CMD nodemon --harmony main.coffee