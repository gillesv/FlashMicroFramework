package views.pages
{
	import framework.paging.pages.AbstractPage;
	
	public class External extends AbstractPage
	{
		public function External()
		{
			super("external", true, true);
		}
		
		override public function init():void{
			trace("external init");
		}
		
		override public function kill():void{
			trace("external kill");
		}
		
		override public function setup(params:*=null):void{
			trace("external setup " + params); 
		}
		
		override public function setupIntro():void{
			trace("custom intro setup!");
		}
		
		override public function animateIn(callback:Function, callbackParams:*):void{
			trace("custom intro animation!! ");
			callback.apply(null, callbackParams);
		}
		
		override public function setupOutro():void{
			trace("custom outro setup!");
		}
		
		override public function animateOut(callback:Function, callbackParams:*):void{
			trace("custom outro animation!! ");
			callback.apply(null, callbackParams);
		}
	}
}