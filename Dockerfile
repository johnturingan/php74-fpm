FROM php:7.4-fpm

MAINTAINER John Turingan <john.turingan@gmail.com>

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    gifsicle \
    git \
    jpegoptim \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev --no-install-recommends \
    libmemcached-dev \
    libpcre3 \
    libpcre3-dev \
    libpng-dev \
    libssl-dev \
    libsodium-dev \
    libzip-dev \
    locales \
    optipng \
    pngquant \
    unzip \
    unzip \
    vim \
    zip \
    zlib1g-dev

# Install memcache extension
RUN apt-get update \
  && apt-get install -y libmemcached-dev zlib1g-dev \
  && pecl install memcached-3.1.5 \
  && docker-php-ext-enable memcached opcache

RUN docker-php-ext-install pdo_mysql mysqli bcmath sockets opcache zip sodium

# Install imagick
RUN pecl install imagick && docker-php-ext-enable imagick

# Install GD extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup timezone to Etc/UTC
#RUN cat /usr/src/php/php.ini-production | sed 's/^;\(date.timezone.*\)/\1 \"Etc\/UTC\"/'

# create the working dir
RUN mkdir -p /srv/http

# Set working directory
WORKDIR /srv/http

# Expose port 9000 and start php-fpm server
EXPOSE 9000

CMD ["php-fpm"]