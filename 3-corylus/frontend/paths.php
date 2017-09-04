<?php

/** The full path to the directory which holds "app", WITHOUT a trailing DS. */
if (!defined('ROOT')) {
    define('ROOT', dirname(dirname(dirname(__FILE__))));
}

/** The actual directory name for the "app". */
if (!defined('APP_DIR')) {
    define('APP_DIR', basename(dirname(dirname(__FILE__))));
}

/** The absolute path to the "cake" directory, WITHOUT a trailing DS. */
if (!defined('CAKE_CORE_INCLUDE_PATH')) {
    define('CAKE_CORE_INCLUDE_PATH', '/var/www/bedita');
}

/** The absolute path to the "BEdita" core directory bedita-app included, WITHOUT a trailing DS. */
if (!defined('BEDITA_CORE_PATH')) {
    define('BEDITA_CORE_PATH', CAKE_CORE_INCLUDE_PATH . DS . 'bedita-app');
}
