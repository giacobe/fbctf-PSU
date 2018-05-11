FROM ubuntu:xenial

ENV HOME /root

ARG DOMAIN
ARG EMAIL
ARG MODE=dev
ARG TYPE=self
ARG KEY
ARG CRT

ENV HHVM_DISABLE_NUMA true

RUN apt-get update && apt-get -y install sudo apt-utils

WORKDIR $HOME
COPY . $HOME
RUN ./extra/provision.sh -m $MODE -c $TYPE -k $KEY -C $CRT -D $DOMAIN -e $EMAIL -s `pwd` --docker

# polyCTF customization
RUN sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo 'memory_limit = 2048M' >> /etc/hhvm/php.ini
RUN echo 'upload_max_filesize = 2400M' >> /etc/hhvm/php.ini
RUN echo 'post_max_size = 2400M' >> /etc/hhvm/php.ini
RUN echo 'max_input_time = 1200' >> /etc/hhvm/php.ini
RUN echo 'max_execution_time = 1200' >> /etc/hhvm/php.ini
RUN sed -i "s/client_max_body_size.*/client_max_body_size 2048M;/" /etc/nginx/sites-available/fbctf.conf



CMD ["./extra/service_startup.sh"]
