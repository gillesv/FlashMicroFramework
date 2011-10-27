package framework.paging
{
	public interface IPage
	{
		function get id():String;
		
		function setup(params:* = null):void;	// called before added to displaytree, to pass optional parameters along to the page
		
		function init():void;	// called when added to layer
		function kill():void;	// called before removal from layer
		
		// setup the intro or outro animations before they occur
		function setupIntro():void;
		function setupOutro():void;
		
		function animateIn(callback:Function, callbackParams:*):void;
		function animateOut(callback:Function, callbackParams:*):void;
		
		function get canAnimateIn():Boolean;
		function get canAnimateOut():Boolean;
	}
}