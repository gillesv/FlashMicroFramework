package views.pages
{
	import core.S;
	
	import flash.events.Event;
	
	import framework.paging.IPage;
	
	public class Contact extends S implements IPage
	{
		public function Contact()
		{
			super();
		}
		
		public function get id():String
		{
			return "contact";
		}
		
		public function setup(params:*=null):void
		{
			
		}
		
		public function setupIntro():void{
			this.alpha = 0;
		}
		
		public function setupOutro():void{
			
		}
		
		private var callback:Function;
		private var callbackParams:*;
		
		public function animateIn(callback:Function, callbackParams:*):void{	
			this.callback = callback;
			this.callbackParams = callbackParams;
			
			addEventListener(Event.ENTER_FRAME, fadein);
		}
		
		private function fadein(evt:Event):void{
			alpha += (1 - alpha)/5;
						
			if(alpha > 0.9){
				alpha = 1;
				
				removeEventListener(Event.ENTER_FRAME, fadein);
								
				callback.apply(null, callbackParams);
			}
		}
		
		public function animateOut(callback:Function, callbackParams:*):void{
			this.callback = callback;
			this.callbackParams = callbackParams;
			addEventListener(Event.ENTER_FRAME, fadeout);
		}
		
		private function fadeout(evt:Event):void{
			alpha += (0 - alpha)/10;
			
			if(alpha <= 0.1){
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