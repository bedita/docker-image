# BEdita official Docker image
[![Docker Pulls](https://img.shields.io/docker/pulls/bedita/bedita.svg)](https://hub.docker.com/r/bedita/bedita/)

This Docker image lets you run a BEdita instance easily and quickly, without need to configure a Webserver, installing a database, or struggling to set the correct file permissions.

Even though it is meant only for **development purposes**, this might also work as a *proof of concept* for running BEdita in a dockerized environment.

## What's in this image

In this image you can expect to find:

 - The latest version of [BEdita](https://github.com/bedita/bedita).
 - The BEdita modules [Books](https://github.com/bedita/books) and [Tickets](https://github.com/bedita/tickets) already installed and plugged-in.
 - The BEdita [Bootstrap frontend](https://github.com/bedita/bootstrap) already installed and available, ready to be used as a REST API frontend (see `GET /api/v1` for available endpoints).

## Getting started

### The easy way

1. Ensure you have Docker Compose installed on your local machine.
2. Clone [this repository](https://github.com/bedita/docker-image).
3. Open the `docker-compose.yml` file and change the default values (`MYSQL_ROOT_PASSWORD`, `MYSQL_PASSWORD` and `BEDITA_MYSQL_PASS`, `BEDITA_CORE_HOST`) according to your needs.
4. Run `docker-compose up -d`
5. Navigate to http://manage.192.168.99.100.xip.io:8083 to access the backend (default user: `bedita` / `bedita`)
6. Navigate to http://192.168.99.100:8083/api/v1 to see a list of available REST API endpoints.

Be sure to replace any instance of `192.168.99.100` inside `docker-compose.yml` and in the URLs above with the actual IP of your Docker machine (if you're running Boot2Docker on OS X, the default value should be fine).

### The “hard” way

First of all, you'll need a MySQL container up and running:

```
docker run -d --name bedita_db -v /var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=my_root_password \
    -e MYSQL_USER=bedita \
    -e MYSQL_PASSWORD=my_bedita_password \
    -e MYSQL_DATABASE=bedita \
    mysql:5.6
```

Once the database container has started, you can start the BEdita container running the following command:

```
docker run -d --name bedita -v /var/www/bedita/bedita-app/webroot/files \
    --link bedita_db:db \
    -e BEDITA_CORE_HOST=manage.192.168.99.100.xip.io \
    -e BEDITA_CORE_PORT=8083 \
    -e BEDITA_DEBUG=2 \
    -e BEDITA_MYSQL_HOST=db \
    -e BEDITA_MYSQL_USER=bedita \
    -e BEDITA_MYSQL_PASS=my_bedita_password \
    -e BEDITA_MYSQL_NAME=bedita \
    -p 8083:80 \
    bedita/bedita
```

Obviously, you are encouraged to replace `my_root_password` and `my_bedita_password` with more secure values.

Also, `BEDITA_CORE_HOST` should be set to a host that points to your Docker machine. In this example, we are using a [xip.io](http://xip.io/) host that points to the default IP for Boot2Docker, but of course you might need to change this.

At this point, you should be able to navigate to http://manage.192.168.99.100.xip.io:8083 (or whatever you set your host to) and see your BEdita CMS login page (default user is `bedita` with password `bedita`). By using any other hostname that points to the same IP, using port `8083`, you will access your frontend. Hence, browsing http://192.168.99.100:8083/api/v1 you should see a JSON response listing the available REST API endpoints.
