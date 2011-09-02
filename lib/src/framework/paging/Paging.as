package framework.paging
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import framework.events.GlobalEvent;
	import framework.events.GlobalEventDispatcher;
	
	public class Paging extends EventDispatcher
	{
		
		private var _container:DisplayObjectContainer;
		private var _factory:IPageFactory;
		
		private var _layers:Array;
		
		public static const LAYER_MAIN:uint = 0;
		public static const LAYER_POPUPS:uint = 1;
		public static const LAYER_UI:uint = 2;
		
		/**
		 * If true, the Paging instance will dispatch its events using the GlobalEventDispatcher. 
		 * Can be handy for projects that have only one, global paging instance and that would allow
		 * all objects to hook into its events without a direct reference to the paging object. 
		 * 
		 * @default: false
		 */		
		public var dispatchGlobalEvents:Boolean = false;
		
		public function Paging()
		{
			super();
			
			_layers = [];
		}
		
		/**
		 * Navigate to a page.
		 *  
		 * @param page		can be multiple types: 
		 * 					1) a string identifier that will be passed to a factory-class to return a proper IPage or DisplayObject
		 * 					2) a Class which when instanced returns a DisplayObject or an IPage object
		 * 					3) a DisplayObject which optionally implements the IPage interface for advanced functionality/increased control
		 * @param params	@optional parameters to be passed to the page, if possible - leave null if not required
		 * @param layer		@optional a numeric index indicating the layer on which a new page is added. (handy for popups/popunders)
		 * 
		 */		
		public function gotoPage(page:*, params:* = null, layer:uint = 0):void{
			if(!_container)
				throw new Error('Paging has no container: please set container property to a non-null value');
			
			if(page == null)
				throw new Error("page shouldn't be null!");
			
			if(page as String && factory == null)
				log("No factory defined! Can't create page '" + page.toString() + "'");
			
			// check layers
		}
		
		/**
		 * Close the page at the current layer
		 *  
		 * @param layer	@optional the numeric index of the layer which page should be closed
		 */		
		public function closePage(layer:uint = 0):void{
			if(!_container)
				throw new Error('Paging has no container: please set container property to a non-null value');
		}
		
		/**
		 * Disable all mouseevents/interactivity for the page in a certain layer. (to prevent clicks through a popover, for example)
		 *  
		 * @param layer	the numeric index of the layer you wish to disable @default: 0 @optional
		 * 
		 */		
		public function disableLayer(layer:uint = 0):void{
			
		}
		
		/**
		 * Enable all mouseevents/interactivity for the page in a certain layer. (to prevent clicks through a popover, for example)
		 *  
		 * @param layer	the numeric index of the layer you wish to disable @default: 0 @optional
		 * 
		 */	
		public function enableLayer(layer:uint = 0):void{
			
		}
		
		/**
		 * Return a reference to the displayObjectcontainer used to layer pages.
		 *  
		 * @param layer	
		 * @return 
		 * 
		 */		
		public function getLayer(layer:uint = 0):DisplayObjectContainer{
			return null;
		}
		
		// *************** OVERRIDES ***************** //
		
		override public function dispatchEvent(event:Event):Boolean{
			if(dispatchGlobalEvents){
				if(event as GlobalEvent)
					GlobalEvent(event).dispatch();
				else
					GlobalEventDispatcher.instance.dispatchEvent(event);
			}
			
			return super.dispatchEvent(event);
		}
		
		// *********** GETTERS & SETTERS ************* //
		
		/**
		 * The container wherin the pages will be created.
		 *  
		 * @return DisplayObjectContainer
		 * 
		 */		
		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function set container(value:DisplayObjectContainer):void
		{
			_container = value;
		}
		
		/**
		 * OPTIONAL Factory which creates new IPage instances from a string identifier.
		 *  
		 * @return IPageFactory
		 * 
		 */		
		public function get factory():IPageFactory
		{
			return _factory;
		}

		public function set factory(value:IPageFactory):void
		{
			_factory = value;
		}
		

	}
}