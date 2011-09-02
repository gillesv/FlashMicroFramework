package framework.paging
{
	public interface IPage
	{
		function setup(params:* = null):void;
		
		function init():void;
		function kill():void;
		
		function animateIn(callback:Function, callbackParams:*):void;
		function animateOut(callback:Function, callbackParams:*):void;
		
		function get canAnimate():Boolean;
	}
}