/* Main.js */

/************************************/
/**** HISTORY.JS -> FLASH BRIDGE ****/
/************************************/

var flash, url;
var body, rootUrl, subDir;

/********/
/* INIT */
/********/

$(document).ready(function(){
	
	// variables
	body = $(document.body);
	rootUrl = document.location.protocol+'//'+(document.location.hostname||document.location.host);
	subDir = baseURL; // if your app lives inside a subdirectory on your webserver, put that here
	
	rootUrl += subDir;	
	
	if(!Modernizr.history){
		// History.js is disabled for this browser.
		// This is because we can optionally choose to support HTML4 browsers or not.
		//return false;
		// First: check if we're on the index page, if not, redirect to the subdirectory		
		if(document.location.toString().split('#')[0].toString() !== rootUrl){
			var hash = '#!/' + document.location.toString().split(rootUrl).join('');
			document.location = rootUrl + hash;
			return;
		}
		
		// Add hashchange listener
		$(window).hashchange(stateChange);
	}else{
		// Bind Statechange event
		History.Adapter.bind(window, 'statechange', stateChange);
	}
	
	// Statechange function
	function stateChange(evt){
		var state;
	
		if(Modernizr.history){
			state = History.getState();
			url = state.url.split(rootUrl).join('');
		}else{
			state = document.location.hash;
			url = state.split('#!/').join('').toString();
		}
		
		switch(url){
			default:
				if(!flash)
					flash = document.getElementById(FLASH_ID);
					
				try{	
					flash.changeState(url, document.title);
				}catch(err){}
			break;
		}
	}
	
	stateChange();	
});

/*******************************/
/* Flash JS bridge: public API */
/*******************************/

// Called to push the first history state to the SWF
function initFlashHistoryBridge(){
	flash = document.getElementById(FLASH_ID);
	
	if(!url){
		url = "";
	}
	
	flash.changeState(url, document.title);
}

// Called from the SWF to change the document's current history state
function flashPushHistoryState(state, title){
	if(!Modernizr.history){
		window.location.hash = "!/" + state;
		document.title = title;
	}else{
		History.pushState(null, title, rootUrl + state);
	}
}

// Called from the SWF to set the Document's titel externally
function flashSetTitle(title){
	document.title = title;
}