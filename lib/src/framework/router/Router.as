package framework.router
{
	import framework.router.utils.PatternMatch;

	public class Router
	{
		private var patterns:Array = [];
		private var _before:Function;
		private var _after:Function;
		
		private var _url:String;
		
		public function Router(){
			
		}
		
		public function goto(url:String):void{
			if(_url != url)
				route(url);
		}
		
		public function before(callback:Function):void{
			this._before = callback;
		}
		
		public function after(callback:Function):void{
			this._after = callback;
		}
		
		public function redirect(url:String):void{
			var tempurl:String = _url;
			
			route(url);
			
			_url = tempurl;
		}
		
		/**
		 * Take the incoming url, match it to an appropriate pattern and call the related callback
		 *  
		 * @param url
		 */		
		public function route(url:String):void{
			if(url.charAt(0) != '/')
				url = '/' + url;
			
			this._url = url;
			
			var pc:PatternCallback, match:PatternMatch, tempurl:String;
						
			// rerouting
			if(_before != null){
				tempurl = _before.apply(null, [url]);
				
				if(tempurl == null)
					return;
				
				if(tempurl != url){
					route(tempurl);
					return;
				}
			}
			
			var found:Boolean = false;
			
			for(var i:int = 0; i < patterns.length; i++){
				if(!found){
					pc = patterns[i] as PatternCallback;
					match = matches(url, pc.pattern);
					
					if(match.isMatch){
						found = true;
						
						if(match.params.length > 0)
							pc.callback.apply(null, match.params);
						else
							pc.callback.apply();
					}	
				}
			}
			
			if(!found){
				log("Routing error: couldn't find route for '" + url + "'");
			}
						
			// rerouting
			if(_after != null){
				tempurl = _after.apply(null, [url]);
				
				if(tempurl == null)
					return;
				
				if(tempurl != url){
					route(tempurl);
					return;
				}
			}
		}
		
		public function addRoute(pattern:String, callback:Function):void{
			patterns.push(new PatternCallback(pattern, callback));
			patterns.sortOn("type", Array.NUMERIC);
		}
		
		public function matches(url:String, pattern:String):PatternMatch {
			var match:PatternMatch = new PatternMatch(url, pattern);
						
			return match;
		}

		public function get URL():String
		{
			return _url;
		}

	}
}
internal class PatternCallback {
	
	public var pattern:String;
	public var callback:Function;
	
	public static const LITERAL:int = 0;
	public static const NAMED:int = 1;
	public static const UNNAMED:int = 2;
	public static const WILDCARD:int = 3;
	
	public var type:int;
	
	function PatternCallback(pattern:String, callback:Function){
		this.pattern = pattern;
		this.callback = callback;
		
		if(pattern.indexOf("**") > 0){
			type = WILDCARD;
		}else if(pattern.indexOf("*") > 0){
			type = UNNAMED;
		}else if(pattern.indexOf(":") > 0){
			type = NAMED;
		}else{
			type = LITERAL;
		}
	}
	
	public function toString():String{
		return pattern;
	}
}