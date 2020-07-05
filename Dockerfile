FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libxslt1-dev \
    libzip-dev \
    libmemcached-dev \
    libgmp-dev \
    curl \
    wget \
    && docker-php-ext-install -j$(nproc) opcache gd mysqli pdo pdo_mysql xsl zip intl soap bcmath exif gmp iconv  \
    && pecl install -a xdebug-2.9.5 && docker-php-ext-enable xdebug \
    && pecl install -a igbinary-3.1.2 && docker-php-ext-enable igbinary \
    && pecl install -a msgpack-2.1.0 && docker-php-ext-enable msgpack \
    && pecl install --nobuild memcached-3.1.5 \
    && cd "$(pecl config-get temp_dir)/memcached" && phpize \
    && ./configure --enable-memcached-igbinary --enable-memcached-msgpack \
    && make -j$(nproc) && make install && cd /tmp/ && docker-php-ext-enable memcached \
    && pecl install -a uploadprogress-1.1.3 && docker-php-ext-enable uploadprogress


RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY ./phpconf/memory_limit.ini $PHP_INI_DIR/conf.d/memory_limit.ini
COPY ./phpconf/opcache.ini $PHP_INI_DIR/conf.d/opcache.ini
COPY ./phpconf/xdebug.ini $PHP_INI_DIR/conf.d/xdebug.ini
COPY ./phpconf/www.conf /usr/local/etc/php-fpm.d/www.conf

EXPOSE 9000
