FROM php:8.1-apache

# Copy php config.
COPY ./docker/conf/php /usr/local/etc/php

RUN apt update

RUN docker-php-ext-install pdo_mysql

RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN pecl install redis && docker-php-ext-enable redis

RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN apt install git -y
RUN apt install vim -y
RUN apt-get install -y default-mysql-client

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
    && docker-php-ext-configure gd --with-jpeg=/usr --with-webp=/usr --with-freetype=/usr \
    && docker-php-ext-install -j$(nproc) gd

# Install Drush globally
RUN curl -OL https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar
RUN mv drush.phar /usr/local/bin/drush
RUN chmod +x /usr/local/bin/drush

RUN a2enmod rewrite