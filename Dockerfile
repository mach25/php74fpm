FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libxslt1-dev \
    libzip-dev \
    libmemcached-dev \
    && docker-php-ext-install -j$(nproc) opcache gd mysqli pdo pdo_mysql xsl zip intl soap \
    && pecl install xdebug-2.9.4 && docker-php-ext-enable xdebug \
    && pecl install memcached-3.1.5 && docker-php-ext-enable memcached


RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY ./phpconf/memory_limit.ini $PHP_INI_DIR/conf.d/
COPY ./phpconf/opcache.ini $PHP_INI_DIR/conf.d/
COPY ./phpconf/www.conf /usr/local/etc/php-fpm.d/
