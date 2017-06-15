FROM php:5.6-apache
# 作者
MAINTAINER lic@goodrain.com
# 时区设置
RUN echo "Asia/Shanghai" > /etc/timezone;dpkg-reconfigure -f noninteractive tzdata

# 安装软件
RUN apt-get update && apt-get install -y \
        php5-mcrypt \
        libmcrypt4 \
        libmcrypt-dev \
        libpng-dev \
        vim \
        unzip \
        net-tools \
        curl \
        imagemagick \
        php-pear \
        php5-dev \
        apache2-threaded-dev \
    --no-install-recommends && rm -r /var/lib/apt/lists/* \
    && pecl install intl


RUN docker-php-ext-install \
        mysql \
        mysqli \
        opcache \
        gd


COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY config/apache2.conf /etc/apache2/apache2.conf
COPY config/ports.conf /etc/apache2/ports.conf


RUN mkdir -p /app/data && mkdir -p /data/ && cd /app
RUN chmod -R 777 /data
COPY run.sh /app
COPY docker-entrypoint.sh /app
RUN chmod +x /app/run.sh
RUN chmod +x /app/docker-entrypoint.sh
ENV VOLUMEPATH=/data
VOLUME ${VOLUMEPATH}
# VOLUME /data
WORKDIR /app

RUN curl -fSL https://releases.wikimedia.org/mediawiki/1.24/mediawiki-1.24.2.tar.gz -o mediawiki.tar.gz && \
    tar -zxf mediawiki.tar.gz && mv mediawiki-1.24.2 mediawiki && rm mediawiki.tar.gz

COPY config/userdefine.png /app/mediawiki/resources/assets/userdefine.png
COPY config/LocalSettings.php /app/mediawiki
ADD config/sql-config/ /app/config/

EXPOSE 5000
ENTRYPOINT ["/app/docker-entrypoint.sh"]
