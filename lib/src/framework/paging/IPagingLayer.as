package framework.paging
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	public interface IPagingLayer extends IEventDispatcher
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
		
		/**
		 * A controller to handle generic animations for pages that don't have custom animations. 
		 */		
		function get transitionController():ITransitionController;
		function set transitionController(value:ITransitionController):void;
		
	}
}