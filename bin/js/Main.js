/* Main.js */

var flash, url;

/* Custom History.JS implementation */
(function(window, undefined){	
	
	// variables
	var body = $(document.body),
	    rootUrl = document.location.protocol+'//'+(document.location.hostname||document.location.host);
		subDir = "/Experience/Microframework/bin/"; // if your app lives inside a subdirectory on your webserver, put that here
	
	rootUrl += subDir;	
	
	if(!History.enabled){
		// History.js is disabled for this browser.
		// This is because we can optionally choose to support HTML4 browsers or not.
		return false;
	}
	
	// Bind Statechange event
	History.Adapter.bind(window, 'statechange', stateChange);
	
	// Statechange function
	function stateChange(){
		var state = History.getState();
		url = state.url.split(rootUrl).join('');
		
		switch(url){
			default:
				if(!flash)
					flash = document.getElementById(FLASH_ID);
					
				try{	
					flash.changeState(url);
				}catch(err){}
			break;
		}
	}
	
	stateChange();
	
	// create dynamic links
	$('a').live('click', function(evt){
		History.pushState(null, $(this).text(), $(this).attr('href'));
		
		evt.preventDefault();
		
		return false;
	});	
})(window);

// Flash JS bridge
function initFlashHistoryBridge(){
	flash = document.getElementById(FLASH_ID);
	
	if(url){
		flash.changeState(url);
	}
}

function flashPushHistoryState(state, title){
	History.pushState(null, title, state);
}