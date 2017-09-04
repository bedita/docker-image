FROM chialab/php:5.6-apache
MAINTAINER dev@chialab.it

ENV BEDITA_MODULES "books tickets"
ENV BEDITA_GIT_BRANCH "3-corylus"

# Install MySQL client and Supervisor.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-client python-pip supervisor \
    && pip install supervisor-stdout

# Install PHP gettext extension.
RUN docker-php-ext-install gettext

# Create Apache virtual host.
COPY apache/* /etc/apache2/sites-enabled/

# Install BEdita.
RUN mkdir -p /var/www/bedita \
    && curl -o /tmp/bedita.tar.gz -L https://github.com/bedita/bedita/tarball/$BEDITA_GIT_BRANCH \
    && tar -xzf /tmp/bedita.tar.gz -C /var/www/bedita --strip=1
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
    && tar -xzf /tmp/bootstrap.tar.gz -C /var/www/bedita/frontends/bootstrap --strip=1
COPY frontend/* /var/www/bedita/frontends/bootstrap/config/

# Clean up.
RUN rm -r /var/lib/apt/lists/* && rm /tmp/*.tar.gz

# Supervisor.
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Entrypoint.
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
VOLUME ["/var/www/bedita/bedita-app/webroot/files"]
WORKDIR /var/www/bedita
ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord"]
