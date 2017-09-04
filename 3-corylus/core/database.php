<?php

class DATABASE_CONFIG
{

    public $default;

    public function __construct()
    {
        $this->default = array(
            'driver' => 'mysql',
            'persistent' => false,
            'connect' => 'mysql_connect',
            'host' => $_ENV['BEDITA_MYSQL_HOST'],
            'login' => $_ENV['BEDITA_MYSQL_USER'],
            'password' => $_ENV['BEDITA_MYSQL_PASS'],
            'database' => $_ENV['BEDITA_MYSQL_NAME'],
            'schema' => '',
            'prefix' => '',
            'encoding' => 'utf8',
        );
    }
}
