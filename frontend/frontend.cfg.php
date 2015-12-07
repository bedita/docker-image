<?php

/**
 * Publication id referenced by frontend,
 * change if different from id = 1 (default)
 */
$config['frontendAreaId'] = 1;

/**
 * show or not objects with status = draft
 * default: show only objects with status = ON
 */
$config['draft'] = true;

/**
 * staging site ? default: false -> production site
 */
$config['staging'] = false;

/**
 * API frontend.
 */
$config['api'] = array('baseUrl' => '/api/v1');
