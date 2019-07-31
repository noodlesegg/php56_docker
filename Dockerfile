FROM php:5.6

RUN apt-get update 

RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install zip

RUN apt-get install -y \
	libz-dev libmemcached-dev libmemcached11 libmemcachedutil2 build-essential memcached \
	&& pecl install memcached-2.2.0 \
	&& echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini \
	&& apt-get remove -y build-essential libmemcached-dev libz-dev \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /tmp/pear

RUN apt-get install -y libmcrypt-dev libpng-dev libmagickwand-dev --no-install-recommends
RUN docker-php-ext-install mcrypt && docker-php-ext-enable mcrypt

RUN pecl install imagick \
	&& docker-php-ext-enable imagick 

RUN docker-php-ext-install gd

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install bcmath 

RUN pecl channel-update pecl.php.net \
	&& pecl install #XDEBUG_VERSION# \
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sS https://getcomposer.org/installer | php

RUN mv composer.phar /usr/local/bin/composer

RUN apt-get install -y libapache2-mod-security2

RUN apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        groff \
        less \
    && pip3 install --upgrade pip \
    && apt-get clean

RUN pip3 --no-cache-dir install --upgrade awscli

CMD ["/bin/bash"]