<?php

/**
 * Standard routes. Change to what you really need.
 */
dispatch('/', 'index');

dispatch('/home', 'index'); // example

dispatch('/splash', 'splash');
dispatch_post('/preferences/save', 'savePrefs');

dispatch(':page', 'pages'); // dispatch all other pages to pages controller. Easy for templating.

/**
 * This should be the last route definition
 */
dispatch('/**', 'index_catchall'); 

/**
 * Function is called before every route is sent to his handler.
 */
function before_route($route) {
	$useFlash = isset($_SESSION['useFlash']) && $_SESSION['useFlash'];
	set('useFlash', $useFlash);
	
	$parts = explode("/", request_uri());

	if(count($parts) > 0)
		$page = $parts[1];
	else
		$page = "";
	
	set('page', implode('/', $parts));
	
	if(!isset($_SESSION['useFlash']) && $page != 'splash' && $page != 'preferences'){
		// store requested route in session to redirect to after splash screen
		$_SESSION['route'] = implode('/', $parts);
		
		redirect('/splash');
	}
}

/**
 * Function is called before output is sent to browser.
 */
function after_route($output) {
  return $output;
}
