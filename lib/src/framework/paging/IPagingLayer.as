package framework.paging
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface IPagingLayer
	{
		
		function addPage(page:DisplayObject):void;
		function removePage():void;
		
		function enable():void;
		function disable():void;
		
		function get isEnabled():Boolean;
		function set isEnabled(value:Boolean):void;
		
		function get activePage():DisplayObject;
		
		/**
		 * What transitiontype should this layer maintain? 
		 */		
		function get transitionType():String;
		function set transitionType(value:String):void;
		
		/* required components */
		
		function get container():DisplayObjectContainer;
		function set container(value:DisplayObjectContainer):void;
	}
}