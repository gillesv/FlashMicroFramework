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
			trace("lol");
		}
		
		override public function kill():void{
			
		}
		
		override public function setup(params:*=null):void{
			
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