<?php

/**
 * Session
*/
session_start();

/**
	Include
*/
$lib_directory = dirname(dirname(__FILE__)) . '/lib/';

set_include_path(get_include_path() . PATH_SEPARATOR . $lib_directory);

/**
	Limonade PHP
*/
require_once('limonade.php');

/**
	PHP config
*/
date_default_timezone_set('Europe/Brussels');

error_reporting(E_ALL & ~E_STRICT & ~E_WARNING & ~E_NOTICE & ~E_DEPRECATED);
ini_set('display_errors', 1);

/**
	Proximity BBDO lib classes
*/
foreach (glob($lib_directory . 'proximitybbdo/*.php') as $filename)
	require_once($filename);

/**
  Init our skeleton app
 */ 
// optionally pass the path to another config file
ProximityApp::init(dirname(dirname(__FILE__)) . "/config/config.yaml");