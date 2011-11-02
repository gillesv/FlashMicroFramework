<?php

/**
 * Standard routes. Change to what you really need.
 */
dispatch('/', 'index');

dispatch('/preferences', 'preferences');
dispatch_post('/preferences/save', 'savePreferences');

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
	
	$parts = explode("/", request_uri());

	if(count($parts) > 0)
		$page = $parts[1];
	else
		$page = "";
	
	
	if($detect->isMobile()){
		if($page == 'preferences'){
			redirect('/');
		}
		return;
	}
		
	// if we haven't saved a user preference for flash and we're not on mobile (TODO), go to a preferences splash page
	if(!isset($_SESSION['useFlash']) && $page != 'preferences'){
		$_SESSION['route'] = implode('/', $parts);
		redirect('/preferences');
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
