/* Main.js */

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
	History.Adapter.bind(window, 'statechange', function(){
		var state = History.getState();
		var url = state.url.split(rootUrl).join('');
		
		switch(url){
			default:
				console.log("url : " + url);
			break;
		}
	});
	
	// create dynamic links
	$('a').live('click', function(evt){
		History.pushState(null, $(this).text(), $(this).attr('href'));
		
		evt.preventDefault();
		
		return false;
	});	
})(window);