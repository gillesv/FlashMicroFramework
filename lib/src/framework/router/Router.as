package framework.router
{
	public class Router
	{
		private var patterns:Array = [];
		private var _before:Function;
		private var _after:Function;
		
		public function Router(){
		}
		
		public function before(callback:Function):void{
			this._before = callback;
		}
		
		public function after(callback:Function):void{
			this._after = _after;
		}
		
		/**
		 * Take the incoming url, match it to an appropriate pattern and call the related callback
		 *  
		 * @param url
		 */		
		public function route(url:String):void{
			var pc:PatternCallback, match:PatternMatch, tempurl:String;
			
			// rerouting
			if(_before != null){
				tempurl = _before.apply(null, [url]);
				
				if(tempurl != url && tempurl != null){
					route(tempurl);
					return;
				}
			}
			
			for(var i:int = 0; i < patterns.length; i++){
				pc = patterns[i] as PatternCallback;
				match = matches(url, pc.pattern);
				
				if(match.isMatch){
					if(match.params.length > 0)
						pc.callback.apply(null, match.params);
					else
						pc.callback.apply();
					
					
					break;
				}	
			}
			
			// rerouting
			if(_after != null){
				tempurl = _after.apply(null, [url]);
				
				if(tempurl != url && tempurl != null){
					route(tempurl);
					return;
				}
			}
		}
		
		public function addRoute(pattern:String, callback:Function):void{
			patterns.push(new PatternCallback(pattern, callback));
		}
		
		protected function matches(url:String, pattern:String):PatternMatch {
			var match:PatternMatch = new PatternMatch(url, pattern);
			
			return match;
		}
	}
}
internal class PatternCallback {
	
	public var pattern:String;
	public var callback:Function;
	
	function PatternCallback(pattern:String, callback:Function){
		this.pattern = pattern;
		this.callback = callback;
	}
}

internal class PatternMatch{
	
	public var isMatch:Boolean = false;
	public var params:Array = [];
	public var url:String;
	public var pattern:String;
	
	function PatternMatch(url:String, pattern:String){
		this.url = url;
		this.pattern = pattern;
		
		match();
	}
	
	private function match():void{
		var els:Array = url.split('/');
		var patEls:Array = pattern.split('/');
		
		// remove prefixed or trailing slashes
		if(els[0] == '')
			els.shift();
		
		if(els[els.length - 1] == '')
			els.pop();
		
		if(patEls[0] == '')
			patEls.shift();
		
		if(patEls[patEls.length - 1] == '')
			patEls.pop();
		
		
		if(pattern.indexOf('**') > 0){ // /deeplink/**	
			
		}else if(pattern.indexOf('*') > 0){ // /deeplink/*
			
		}else if(pattern.indexOf(':') > 0){ // /deeplink/:var/:var
			
		}else{ // /deeplink or /deeplink/deeperlink
			
		}
	}
	
}