package views.pages
{
	import core.S;
	
	import flash.events.Event;
	
	import framework.paging.IPage;
	
	public dynamic class Home extends S implements IPage
	{
		public function Home()
		{
			super();
		}
		
		public function get id():String
		{
			return "home";
		}
		
		public function setup(params:*=null):void
		{
			trace("params received: " + params);
			this.alpha = 0;
		}
		
		private var callback:Function;
		private var callbackParams:*;
		
		public function animateIn(callback:Function, callbackParams:*):void{	
			log("home animateIn");
			this.callback = callback;
			this.callbackParams = callbackParams;
			
			addEventListener(Event.ENTER_FRAME, fadein);
		}
		
		private function fadein(evt:Event):void{
			alpha += (1 - alpha)/5;
						
			if(alpha > 0.99){
				alpha = 1;
				
				removeEventListener(Event.ENTER_FRAME, fadein);
				
				callback.apply(null, callbackParams);
			}
		}
		
		public function animateOut(callback:Function, callbackParams:*):void{
			log("home animateOut");
			
			this.callback = callback;
			this.callbackParams = callbackParams;
			addEventListener(Event.ENTER_FRAME, fadeout);
		}
		
		private function fadeout(evt:Event):void{
			alpha -= Math.max(.1, (alpha/2));
			
			if(alpha <= 0.1640625){
				alpha = 0;
				
				removeEventListener(Event.ENTER_FRAME, fadeout);
				
				callback.apply(null, callbackParams);
			}
		}
		
		public function get canAnimateIn():Boolean
		{
			return true;
		}
		
		public function get canAnimateOut():Boolean
		{
			return true;
		}
	}
}