# BEdita official Docker image

[![Docker Pulls](https://img.shields.io/docker/pulls/bedita/bedita.svg)](https://hub.docker.com/r/bedita/bedita/)

This Docker image lets you run a BEdita instance easily and quickly, without need to configure a Webserver, installing a database, or struggling to set correct file permissions.

Even though it is meant only for **development purposes**, this might also serve as a _proof of concept_ for running BEdita in a dockerized environment.

## What’s in this image

In this image you will find:

 - The latest version of [BEdita4](https://github.com/bedita/bedita) on current main branch `4-cactus`.

If you're looking for the old BEdita 3 image [read here](https://github.com/bedita/docker-image/blob/master/3-corylus/README.md).

## Available tags and `Dockerfile` links

- [`latest` (_Dockerfile_)](https://github.com//bedita/docker-image/blob/master/Dockerfile)

## Quick reference

-	**Where to file issues**:  
	[https://github.com/bedita/docker-image/issues](https://github.com/bedita/docker-image/issues)

-	**Maintained by**:  
	[the BEdita Team](https://github.com/bedita)

## Getting started

Make sure you have a recent version of [Docker](https://www.docker.com/) installed on your machine.

Pull latest image:
```bash
docker pull bedita/bedita
```

You may use `:latest` or `:4-cactus` tags, they have currently same effect.

### Quick launch

Easiest way to launch the container after the image has been successfully pulled is:

```bash
docker run -p 8090:80 bedita/bedita
```

This will launch a BEdita instance that uses SQLite as its storage backend. It should become available at http://localhost:8090/home almost instantly.

### Using PostgreSQL or MySQL via linked containers

Other database backends can be used with BEdita by launching the database server in a separate Docker container.

A MySQL 5.7 server can be launched in a container launching this command:

```bash
docker run -d --name mysql \
  --env MYSQL_ROOT_PASSWORD=root \
  --env MYSQL_DATABASE=bedita \
  --env MYSQL_USER=bedita \
  --env MYSQL_PASSWORD=bedita \
  mysql:5.7
```

Then, a BEdita instance can be configured to use MySQL as its backend launching this command:

```bash
docker run -d --name=bedita \
  --env DATABASE_URL=mysql://bedita:bedita@mysql:3306/bedita \
  -p 8090:80 --link mysql:mysql \
  bedita/bedita
```

The BEdita container will automatically wait until MySQL container becomes available, then will run connect to it, launch required schema migrations, and start the Web server. The application should become available at http://localhost:8090/home in a matter of few seconds. However, depending on the responsiveness of MySQL container, this might take longer.

## Logging

Logs are written to stdout and sterr, so that they can be inspected via `docker logs`. This is considered a common practice for Docker containers, and there are tools that can collect and ingest logs written this way. However, `LOG_ERROR_URL` and `LOG_DEBUG_URL` can be overwritten at container launch via `--env` flag to send logs to a different destination. For instance, one might want to launch a Logstash container, link it to BEdita container, and send BEdita logs to Logstash.


### Available options

The following options should be passed to the container as environment variables using the `--env` flag.

#### `BEDITA_API_KEY`

Initial default **API KEY** on a newly created client application.

You may use this **API KEY** to [use a client application with BEdita](https://docs.bedita.net/en/latest/authorization.html?#application-identification).

#### `BEDITA_APP_NAME`

Application name to be used if an **API KEY** is set via `BEDITA_API_KEY` - otherwise a default `manager` name is used.

Option will be ignored if no `BEDITA_API_KEY` is present.

#### `BEDITA_ADMIN_USR`

Initial admin username.

`BEDITA_ADMIN_PWD` MUST also be present in order for this option to be used 

#### `BEDITA_ADMIN_PWD`

Initial admin password.

`BEDITA_ADMIN_USR` MUST also be present in order for this option to be used 

#### Usage example

```bash
docker run -p 8090:80 --env BEDITA_API_KEY=1029384756 --env BEDITA_APP_NAME=my-app --env BEDITA_ADMIN_USR=admin --env BEDITA_ADMIN_PWD=admin bedita4-image
```

On docker image startup a new client application with `1029384756` as **API KEY**  and `my-app` as name is set.

Initial admin username and password are also set.