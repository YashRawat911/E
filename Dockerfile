# Use the official PHP Apache image
FROM php:apache

# Set environment variables
ENV ROUNDCUBE_VERSION=1.5.2

# Install dependencies
RUN apt-get update && apt-get install -y \
    libapache2-mod-xsendfile \
    libpng-dev \
    libjpeg-dev \
    libpq-dev \
    libxml2-dev \
    libxslt-dev \
    zlib1g-dev \
    mariadb-client \
    git \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure gd --with-jpeg \
 && docker-php-ext-install pdo_mysql mysqli gd gettext xmlrpc xml xsl zip \
 && a2enmod rewrite \
 && echo 'sendmail_path = /bin/true' > /usr/local/etc/php/conf.d/sendmail.ini

# Download and extract Roundcube
RUN curl -o roundcube.tar.gz -SL https://github.com/roundcube/roundcubemail/releases/download/$ROUNDCUBE_VERSION/roundcubemail-$ROUNDCUBE_VERSION-complete.tar.gz \
 && tar -xzf roundcube.tar.gz -C /var/www/html --strip-components=1 \
 && rm roundcube.tar.gz \
 && chown -R www-data:www-data /var/www/html

# Expose ports
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
