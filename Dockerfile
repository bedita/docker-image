FROM chialab/php:5.6-apache
MAINTAINER dev@chialab.it

ENV BEDITA_MODULES books tickets
ENV BEDITA_GIT_BRANCH 3-corylus

# Install Git and MySQL client.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git mysql-client \
    && rm -r /var/lib/apt/lists/*

# Install PHP gettext extension.
RUN docker-php-ext-install gettext

# Install BEdita.
RUN git clone --branch $BEDITA_GIT_BRANCH https://github.com/bedita/bedita.git /var/www/bedita && \
    chmod -R 777 /var/www/bedita/bedita-app/tmp && \
    chmod -R 777 /var/www/bedita/bedita-app/webroot/files
COPY core/* /var/www/bedita/bedita-app/config/

# Install modules.
RUN for module in $BEDITA_MODULES; do git clone https://github.com/bedita/$module.git /var/www/bedita/modules/$module; done

# Install frontend.
RUN git clone https://github.com/bedita/bootstrap.git /var/www/bedita/frontends/bootstrap && \
    chmod -R 777 /var/www/bedita/frontends/bootstrap/tmp
COPY frontend/* /var/www/bedita/frontends/bootstrap/config/

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
