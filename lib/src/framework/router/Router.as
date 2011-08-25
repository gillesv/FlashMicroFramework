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
			patterns.sortOn("type", Array.NUMERIC);
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
				
		var valid:Boolean = true;
		var compare:String = "";
		var unnamed:Array = [];
		
		params = [];
		
		for(var i:int = 0; i < els.length; i++){
			if(valid){
				compare = patEls[Math.min(patEls.length - 1, i)];
								
				if(compare == "**"){
					unnamed.push(els[i]);
				}else if(compare == "*"){
					unnamed.push(els[i]);
				}else if(compare.indexOf(":") == 0){
					params.push(els[i]);
				}else if(compare != els[i]){
					valid = false;
				}
			}
		}
		
		// incorrect amount of parameters defined
		if(pattern.indexOf(":") >= 0 && (pattern.split(":").length - 1 > params.length)){
			valid = false;
		}
				
		if(pattern.indexOf("**") >= 0 && unnamed.length > 0){
			params.push(unnamed.join("/"));
		}
		
		if(pattern.indexOf("**") < 0 && unnamed.length > 0)
			params.push(unnamed);
				
		if(valid)
			isMatch = true;
	}
	
}