FROM chialab/php:5.6-apache
MAINTAINER dev@chialab.it

ENV BEDITA_MODULES "books tickets"
ENV BEDITA_GIT_BRANCH "3-corylus"

# Install MySQL client.
RUN packages=" \
        mysql-client \
    " \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y $packages \
    && rm -r /var/lib/apt/lists/*

# Install PHP gettext extension.
RUN docker-php-ext-install gettext

# Install BEdita.
RUN mkdir -p /var/www/bedita \
    && curl -o /tmp/bedita.tar.gz -L https://github.com/bedita/bedita/tarball/$BEDITA_GIT_BRANCH \
    && tar -xzf /tmp/bedita.tar.gz -C /var/www/bedita --strip=1 \
    && chmod -R 777 /var/www/bedita/bedita-app/tmp \
    && chmod -R 777 /var/www/bedita/bedita-app/webroot/files
COPY core/* /var/www/bedita/bedita-app/config/

# Install modules.
RUN for module in $BEDITA_MODULES; do \
        mkdir -p /var/www/bedita/modules/$module \
        && curl -o /tmp/$module.tar.gz -L https://github.com/bedita/$module/tarball/master \
        && tar -xzf /tmp/$module.tar.gz -C /var/www/bedita/modules/$module --strip=1; \
    done

# Install frontend.
RUN mkdir -p /var/www/bedita/frontends/bootstrap \
    && curl -o /tmp/bootstrap.tar.gz -L https://github.com/bedita/bootstrap/tarball/master \
    && tar -xzf /tmp/bootstrap.tar.gz -C /var/www/bedita/frontends/bootstrap --strip=1 \
    && chmod -R 777 /var/www/bedita/frontends/bootstrap/tmp
COPY frontend/* /var/www/bedita/frontends/bootstrap/config/

# Clean up temporary files.
RUN rm /tmp/*.tar.gz

# Create Apache virtual host.
COPY apache/* /etc/apache2/sites-enabled/

# Entrypoint.
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
VOLUME ["/var/www/bedita/bedita-app/webroot/files"]
WORKDIR /var/www/bedita
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
