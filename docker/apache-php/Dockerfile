FROM php:7.3.20-apache

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions zip xsl xmlrpc tidy sysvsem sysvshm sysvmsg sockets soap redis pspell pgsql pdo_pgsql pdo_mysql pdo_odbc pdo_sqlite opcache odbc mysqli ldap intl imap imagick gmp gd gettext exif enchant dba calendar bz2 bcmath
RUN install-php-extensions xdebug

RUN a2enmod rewrite
