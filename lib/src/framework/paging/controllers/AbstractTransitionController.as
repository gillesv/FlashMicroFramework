package framework.paging.controllers
{
	import flash.display.DisplayObject;
	
	import framework.paging.ITransitionController;
	
	public class AbstractTransitionController implements ITransitionController
	{
		public function AbstractTransitionController()
		{
		}
		
		public function setupIntro(page:DisplayObject):void{
			// do nothing
		}
		
		public function setupOutro(page:DisplayObject):void{
			// do nothing
		}
		
		public function animatePageIn(page:DisplayObject, callback:Function, callbackParams:*):void{
			callback.apply(null, callbackParams);
		}
		
		public function animatePageOut(page:DisplayObject, callback:Function, callbackParams:*):void{
			callback.apply(null, callbackParams);
		}
	}
}