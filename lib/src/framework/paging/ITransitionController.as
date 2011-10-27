package framework.paging
{
	import flash.display.DisplayObject;
	
	public interface ITransitionController{
		
		/**
		 * Allow the controller to preset a few properties in preparation of showing the animation.
		 * For instance, this would allow you to set the alpha to 0 for a page that's waiting to be
		 * transitioned in, or to precache a bitmap to animate instead of a sprite, etc...
		 *  
		 * @param page
		 * 
		 */		
		function setupIntro(page:DisplayObject):void;
		function setupOutro(page:DisplayObject):void;
		
		function animatePageIn(page:DisplayObject, callback:Function, callbackParams:*):void;
		function animatePageOut(page:DisplayObject, callback:Function, callbackParams:*):void;
		
	}
}