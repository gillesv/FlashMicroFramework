/* Main.js */

/************************************/
/**** HISTORY.JS -> FLASH BRIDGE ****/
/************************************/

var flash, url;
var body, rootUrl, subDir;

/********/
/* INIT */
/********/

(function(window, undefined){	
	
	// variables
	body = $(document.body);
	rootUrl = document.location.protocol+'//'+(document.location.hostname||document.location.host);
	subDir = "/Experience/Microframework/bin/"; // if your app lives inside a subdirectory on your webserver, put that here
	
	rootUrl += subDir;	
	
	if(!History.enabled){
		// History.js is disabled for this browser.
		// This is because we can optionally choose to support HTML4 browsers or not.
		//return false;
	}
	
	// Bind Statechange event
	History.Adapter.bind(window, 'statechange', stateChange);
	
	// Statechange function
	function stateChange(){
		if(History.enabled){
			var state = History.getState();
			url = state.url.split(rootUrl).join('');
		}else{
			var state = document.location.hash;
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
})(window);

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
	if(!History.enabled){
		window.location.hash = "!/" + state;
		flash.changeState(state, document.title);
	}else{
		History.pushState(null, title, rootUrl + state);
	}
}

// Called from the SWF to set the Document's titel externally
function flashSetTitle(title){
	document.title = title;
}