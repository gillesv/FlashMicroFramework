package views.pages
{
	import framework.paging.pages.AbstractPage;
	
	public class External extends AbstractPage
	{
		public function External()
		{
			super("external", false, false);
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
			
		}
		
		override public function animateIn(callback:Function, callbackParams:*):void{
			
		}
		
		override public function setupOutro():void{
			
		}
		
		override public function animateOut(callback:Function, callbackParams:*):void{
			
		}
	}
}