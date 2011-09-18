package framework.paging
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface IPaging extends IPagingLayer
	{
		
		function gotoPage(page:*, pageParameters:* = null, layer:uint = 1):void;
		
		function closePage(layer:uint = 1):void;
		
		function enableLayer(layer:uint):void;
		function disableLayer(layer:uint):void;
		
		function isLayerEnabled(layer:uint):Boolean;
		function setIsLayerEnabled(value:Boolean, layer:uint):void;
		
		function getActivePageAtLayer(layer:uint):DisplayObject;
		
		/* getters & setters */
		
		function getLayer(layer:uint = 1):IPagingLayer;
		function getLayerContainer(layer:uint = 1):DisplayObjectContainer;
		
		function setTransitionControllerForLayer(controller:ITransitionController, layer:uint):void;
		function getTransitionControllerForLayer(layer:uint):ITransitionController;
		
		function get dispatchGlobalEvents():Boolean;
		function set dispatchGlobalEvents(value:Boolean):void;
		
		/* required components */
		
		function get factory():IPageFactory;
		function set factory(value:IPageFactory):void;
		
		function get container():DisplayObjectContainer;
		function set container(value:DisplayObjectContainer):void;
	}
}