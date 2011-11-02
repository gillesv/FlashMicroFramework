<?php

/**
 * Standard routes. Change to what you really need.
 */
dispatch('/', 'index');

dispatch('/splash', 'splash');
dispatch('/preferences', 'splash');
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
	
  	$detect = new Mobile_Detect();
	
	if($detect->isMobile()){
		return;
	}
	
	$parts = explode("/", request_uri());

	if(count($parts) > 0)
		$page = $parts[1];
	else
		$page = "";
	
	// if we haven't saved a user preference for flash and we're not on mobile (TODO), go to a preferences splash page
	if(!isset($_SESSION['useFlash']) && $page != 'splash' && $page != 'preferences'){
		$_SESSION['route'] = implode('/', $parts);
		redirect('/splash');
	}
	
	$useFlash = isset($_SESSION['useFlash']) && $_SESSION['useFlash'];
	set('useFlash', $useFlash);
}

/**
 * Function is called before output is sent to browser.
 */
function after_route($output) {
  return $output;
}
