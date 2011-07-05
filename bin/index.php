<?php

/**
	Config files
*/
require_once('config/bootstrap.php');
require_once('config/helpers.php');
require_once('config/routes.php');

/**
	Extra configuration
*/
function configure() {
  define('BASE_PATH', str_replace('\\', '', dirname(dirname($_SERVER['SCRIPT_NAME']) . '/.') ));

  option('env', ENV_DEVELOPMENT);  
  option('base_uri', BASE_PATH);
}

/**
	Start
*/
run();
