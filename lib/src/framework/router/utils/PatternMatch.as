package framework.router.utils
{
	public class PatternMatch{
		
		private var _isMatch:Boolean = false;
		private var _params:Array = [];
		private var _url:String;
		private var _pattern:String;
		
		function PatternMatch(url:String, pattern:String){
			this._url = url;
			this._pattern = pattern;
			
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
			
			if(els.length == 0)
				els.push("");
			
			if(patEls.length == 0)
				patEls.push("");
			
			// match url to pattern & sort/store appropriate variables/parameters
			var valid:Boolean = true;
			var compare:String = "";
			var unnamed:Array = [];
			
			_params = [];
			
			// check for literal
			if(els.join("/") != patEls.join("/")){
				if(els.length == 0){
					valid = false;
				}
				
				for(var i:int = 0; i < els.length; i++){
					if(valid){
						compare = patEls[Math.max(0, Math.min(patEls.length - 1, i))];
						
						//trace("compare: "+ compare + " els[" + i + "]: " + els[i]);
						
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
				_isMatch = true;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get pattern():String
		{
			return _pattern;
		}
		
		public function get params():Array
		{
			return _params;
		}
		
		public function get isMatch():Boolean
		{
			return _isMatch;
		}
		
	}
}