package framework.paging
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import framework.events.GlobalEventDispatcher;
	
	public class Paging extends EventDispatcher implements IPaging 
	{
		public static const DEFAULT_LAYER:uint = 1;
		public static const MAX_LAYERS:int = 4;
		
		private var layers:Array = new Array(4);
		private var _container:Sprite;
		private var _factory:IPageFactory;
		private var _dispatchGlobalEvents:Boolean = false;
		
		public function Paging(container:Sprite){
			this._container = container;
		}
		
		public function gotoPage(page:*, pageParameters:*=null, layer:uint=DEFAULT_LAYER):void{
			// interpret page
			var p:DisplayObject;
			
			// page can be either a string (factoryId) or a displayObject or a Class
			
			// validate as factoryId
			if(page as String && factory == null){
				throw new Error("Can't create page with id " + page + " as there's no PageFactory defined");
				return;
			}else if(page as String){
				p = factory.createPage(page) as DisplayObject;
				
				if(p == null){
					throw new Error("Invalid page id " + page + " - Factory can't create a valid page object for provided id");
					return;
				}
			}
			
			// validate class
			if(page as Class){
				p = new page() as DisplayObject;
				
				if(p == null){
					throw new Error("Provided class isn't a DisplayObject!");
					return;
				}
			}
			
			// validate as displayobject
			if(page as DisplayObject){
				p = page;
			}
			
			// validate layer
			if(layer > MAX_LAYERS - 1){
				throw new Error("Invalid layer selected. Please choose one of the layers defined in the PagingLayers Construct");
				return;
			}
			
			// validate final catch-all
			if(p == null){
				throw new Error("Invalid page parameter: page must be either a string, Class or DisplayObject");
				return;
			}
			
			// Okay, if we got this far it *must* be valid
			
			// if we're so kind as to implement the correct interface, use it
			if(p as IPage){
				IPage(p).setup(pageParameters);
			}
			
			// now delegate to the paginglayer
			getLayer(layer).addPage(p);
		}
		
		public function closePage(layer:uint=DEFAULT_LAYER):void{
			// validate layer
			if(layer > MAX_LAYERS - 1){
				throw new Error("Invalid layer selected. Please choose one of the layers defined in the PagingLayers Construct");
				return;
			}
			
			getLayer(layer).removePage();
		}
		
		public function enableLayer(layer:uint):void{
			if(layer > MAX_LAYERS -1)
				return;
			
			getLayer(layer).enable();
		}
		
		public function disableLayer(layer:uint):void	{
			if(layer > MAX_LAYERS -1)
				return;
			
			getLayer(layer).disable();
		}
		
		public function isLayerEnabled(layer:uint):Boolean	{
			if(layer > MAX_LAYERS -1)
				return false;
			
			return getLayer(layer).isEnabled;
		}
		
		public function setIsLayerEnabled(value:Boolean, layer:uint):void {
			if(value)
				enableLayer(layer);
			else
				disableLayer(layer);
		}
		
		public function getActivePageAtLayer(layer:uint):DisplayObject {
			if(layer > MAX_LAYERS - 1)
				return null;
			
			return getLayer(layer).activePage;
		}
		
		public function getLayer(layer:uint=DEFAULT_LAYER):IPagingLayer{
			if(layer > MAX_LAYERS - 1)
				return null;
			
			if(layers[layer] == undefined || layers[layer] == null){
				var pl:PagingLayer = new PagingLayer(layer, this);
								
				layers[layer] = pl;
				
				container.addChild(layers[layer]);
			}
			
			return layers[layer];
		}
		
		public function getLayerContainer(layer:uint=DEFAULT_LAYER):DisplayObjectContainer{
			if(layer > MAX_LAYERS - 1)
				return null;
			
			return getLayer(layer).container;
		}
		
		public function setTransitionControllerForLayer(controller:ITransitionController, layer:uint):void{
			if(layer > MAX_LAYERS - 1)
				return;
			
			if(controller == null)
				return;
			
			getLayer(layer).transitionController = controller;
		}
		
		public function getTransitionControllerForLayer(layer:uint):ITransitionController{
			if(layer > MAX_LAYERS - 1)
				return null;
			
			
			return getLayer(layer).transitionController;
		}
		
		public function get dispatchGlobalEvents():Boolean{
			return _dispatchGlobalEvents;
		}
		
		public function set dispatchGlobalEvents(value:Boolean):void{
			_dispatchGlobalEvents = value;
		}
		
		override public function dispatchEvent(event:Event):Boolean{
			if(_dispatchGlobalEvents){
				GlobalEventDispatcher.instance.dispatchEvent(event);
			}
			
			return super.dispatchEvent(event);
		}
		
		public function get factory():IPageFactory{
			return _factory;
		}
		
		public function set factory(value:IPageFactory):void{
			_factory = value;
		}
		
		public function get container():DisplayObjectContainer{
			return _container;
		}
		
		public function get index():uint{
			return 0;
		}
		
		public function addPage(page:DisplayObject):void{
			gotoPage(page, null);
		}
		
		public function removePage():void{
			closePage();
		}
		
		public function enable():void{
			enableLayer(DEFAULT_LAYER);
		}
		
		public function disable():void{
			disableLayer(DEFAULT_LAYER);
		}
		
		public function get isEnabled():Boolean
		{
			return isLayerEnabled(DEFAULT_LAYER);
		}
		
		public function set isEnabled(value:Boolean):void{
			setIsLayerEnabled(value, DEFAULT_LAYER);
		}
		
		public function get activePage():DisplayObject	{
			return getActivePageAtLayer(DEFAULT_LAYER);
		}
		
		public function get transitionType():String
		{
			return getLayer(DEFAULT_LAYER).transitionType;
		}
		
		public function set transitionType(value:String):void{	
			getLayer(DEFAULT_LAYER).transitionType = value;
		}
		
		public function getTransitionTypeForLayer(layer:uint):String{
			if(layer > MAX_LAYERS - 1)
				return null;
			
			return getLayer(layer).transitionType;
		}
		public function setTransitionTypeForLayer(value:String, layer:uint):void{
			if(layer > MAX_LAYERS - 1)
				return;
			
			getLayer(layer).transitionType = value;
		}
		
		public function get transitionController():ITransitionController{
			return getLayer(DEFAULT_LAYER).transitionController;
		}
		
		public function set transitionController(value:ITransitionController):void{
			if(!value)
				return;
			
			getLayer(DEFAULT_LAYER).transitionController = value;
		}
	}
}