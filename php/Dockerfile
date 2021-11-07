FROM php:7.4-fpm-alpine
ARG IDEKEY
ARG XDEBUG
ARG MEMORY_LIMIT

COPY php.ini /usr/local/etc/php/php.ini
COPY entrypoint.sh /root/entrypoint.sh
RUN apk --update --no-cache add \ 
    bash \
    shadow \
	curl \
	vim \
	git \
	tree \
	php7 \
	php7-bcmath \
	php7-cli \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-fpm \
	php7-gd \
	php7-iconv \
	php7-intl \
	php7-json \
	php7-mbstring \
	php7-mcrypt \
	php7-openssl \
	php7-pdo_mysql \
    php7-mysqli \
	php7-phar \
	php7-session \
	php7-simplexml \
	php7-soap \
	php7-tokenizer \
	php7-xml \
	php7-xmlwriter \
	php7-xsl \
	php7-zip \
	php7-zlib \
    libxml2-dev libpng-dev icu-dev libzip-dev freetype-dev libpng-dev jpeg-dev libjpeg-turbo-dev g++ make autoconf libxslt-dev \
    && docker-php-ext-enable opcache sodium \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install mysqli pdo pdo_mysql gd intl soap bcmath zip xsl sockets \
    && docker-php-ext-enable mysqli pdo pdo_mysql gd intl soap bcmath zip xsl sockets \
    && if [ "$XDEBUG" = "True"]; then \
    pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.discover_client_host=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=${IDEKEY}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    fi \
	&& apk add composer \
	&& sed -i 's/memory_limit = .*/memory_limit = '${MEMORY_LIMIT}'/' /usr/local/etc/php/php.ini 
WORKDIR /var/www/html
ENTRYPOINT [ "/root/entrypoint.sh"]
EXPOSE 9000
