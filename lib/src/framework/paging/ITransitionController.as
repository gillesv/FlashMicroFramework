package framework.paging
{
	import flash.display.DisplayObject;
	
	public interface ITransitionController{
		
		function animatePageIn(page:DisplayObject, callback:Function, callbackParams:*):void;
		function animatePageOut(page:DisplayObject, callback:Function, callbackParams:*):void;
		
	}
}