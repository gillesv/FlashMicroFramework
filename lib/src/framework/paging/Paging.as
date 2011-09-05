package framework.paging
{
	import flash.display.DisplayObject;
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
		
		public static const LAYER_POPUNDER:uint = 0;	// layer for adding changing content below the default (useful for animations/backgrounds/scenes/etc... upon which content can be layered)
		public static const LAYER_DEFAULT:uint = 1;	// default content layer
		public static const LAYER_UI:uint = 2;		// layer for adding global UI elements (header/footer/nav/etc...) on top of the content
		public static const LAYER_POPUPS:uint = 3;	// top-most layer for popups
		
		private var _transitions:Array;
		
		public static const TRANSITION_IN_OUT:String = "in_out";		// old page is animated out, then the new page is animated in
		public static const TRANSITION_IN:String = "in";				// old page is instantly removed/killed, new page animates in
		public static const TRANSITION_CROSSFADE:String = "crossFade";	// old page and new page simultaneously transition out and in, respectively
		
		private var _valid_transitions:Array = [TRANSITION_IN_OUT, TRANSITION_IN, TRANSITION_CROSSFADE];
		
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
			
			_layers = new Array(4);
			_transitions = [TRANSITION_IN_OUT, TRANSITION_IN_OUT, TRANSITION_IN_OUT, TRANSITION_IN_OUT];
		}
		
		/**
		 * Navigate to a page.
		 *  
		 * @param page		can be multiple types: 
		 * 					1) a string identifier that will be passed to a factory-class to return an object of the type DisplayObject implementing the IPage interface.
		 * 					2) a Class which when instanced returns a DisplayObject or an IPage object
		 * 					3) a DisplayObject which optionally implements the IPage interface for advanced functionality/increased control
		 * @param params	@optional parameters to be passed to the page, if possible - leave null if not required
		 * @param layer		@optional a numeric index indicating the layer on which a new page is added. (handy for popups/popunders) @default LAYER_DEFAULT
		 * 
		 */		
		public function gotoPage(page:*, params:* = null, layer:uint = LAYER_DEFAULT):void{
			// validate internals
			if(!_container){
				throw new Error('Paging has no container: please set container property to a non-null value');
				return;
			}
				
			if(page == null){
				throw new Error("page shouldn't be null!");
				return;
			}
			
			// validate layer
			if(layer > LAYER_POPUPS){
				throw new Error("Invalid layer parameter: " + layer);
			}
			
			// vars
			var pageObject:IPage, pageDisplay:DisplayObject, layerContainer:DisplayObjectContainer, prevPage:*, prevPageDisplay:DisplayObject;
			var i:int = 0;
			
			// interpret page
			
			// case 1: page as string
			if(page as String && factory == null){
				throw new Error("No factory defined! Can't create page for id '" + page.toString() + "'.");
				return;
			}else if(page as String && factory != null){
				// page as string, try to create an IPage object via the supplied Factory
				pageObject = factory.createPage(page);
				
				if(pageObject == null){
					throw new Error("Error: Can't create page for id '" + page.toString() + "'.");
					return;
				}
				
				pageDisplay = pageObject as DisplayObject;
				
				if(pageDisplay == null){
					throw new Error("Error: generated page with id '" + page.toString() + "' is not a DisplayObject.");
					return;
				}
			}
			
			// case 2: page as Class
			if(page as Class){
				pageDisplay = new page() as DisplayObject;
				
				if(pageDisplay == null){
					throw new Error("Error: object instanced from page() is not a DisplayObject.");
					return;
				}
				
				pageObject = pageDisplay as IPage; // IPage implementation is optional
			}
			
			// case 3: page as DisplayObject
			if(page as DisplayObject){
				pageDisplay = page as DisplayObject;
				
				pageObject = pageDisplay as IPage; // IPage implementation is optional
			}
			
			// catch all:
			if(pageDisplay == null){
				throw new Error("Error: invalid page parameter: page must be either an id (type String) which can be instanced by the factory, a Class which can be instanced as a DisplayObject or a DisplayObject.");
				return;
			}
			
			// check layers
			layerContainer = getLayer(layer);
			if(layerContainer == null)
				throw new Error("Invalid layer! - This shouldn't happen!");	// TODO: validate this never happens
			
			// check for a previous page
			prevPageDisplay = getPageAtLayer(layer);
			
			// transition scenarios
			
		}
		
		/**
		 * Close the page at the current layer
		 *  
		 * @param layer	@optional the numeric index of the layer which page should be closed @default: LAYER_DEFAULT
		 */		
		public function closePage(layer:uint = LAYER_DEFAULT):void{
			if(!_container)
				throw new Error('Paging has no container: please set container property to a non-null value');
			
			if(layer > LAYER_POPUPS)
				return;
		}
		
		/**
		 * Disable all mouseevents/interactivity for the page in a certain layer. (to prevent clicks through a popover, for example)
		 *  
		 * @param layer	the numeric index of the layer you wish to disable @default: LAYER_DEFAULT @optional
		 * 
		 */		
		public function disableLayer(layer:uint = LAYER_DEFAULT):void{
			if(!_container)
				throw new Error('Paging has no container: please set container property to a non-null value');
			
			if(layer > LAYER_POPUPS)
				return;
			
			var layerDO:DisplayObjectContainer = getLayer(layer);
			
			layerDO.mouseChildren = layerDO.mouseEnabled = false;
		}
		
		/**
		 * Enable all mouseevents/interactivity for the page in a certain layer. (to prevent clicks through a popover, for example)
		 *  
		 * @param layer	the numeric index of the layer you wish to disable @default: 0 @optional
		 * 
		 */	
		public function enableLayer(layer:uint = LAYER_DEFAULT):void{
			if(!_container)
				throw new Error('Paging has no container: please set container property to a non-null value');
			
			if(layer > LAYER_POPUPS)
				return;
			
			var layerDO:DisplayObjectContainer = getLayer(layer);
			
			layerDO.mouseChildren = layerDO.mouseEnabled = true;
		}
		
		/**
		 * Return a reference to the displayObjectcontainer used to layer pages.
		 *  
		 * @param layer	
		 * @return 
		 * 
		 */		
		public function getLayer(layer:uint = LAYER_DEFAULT):DisplayObjectContainer{
			if(!_container)
				throw new Error('Paging has no container: please set container property to a non-null value');				
			
			if(layer > LAYER_POPUPS)
				return null;
			
			if(_layers[layer] == null){
				var tempLayer:Sprite, layerContainer:Sprite, i:int;
				
				layerContainer = _layers[layer] = new Sprite();
				layerContainer.name = "layer_" + layer.toString();
				_container.addChild(layerContainer);
				
				// make sure all layers are correctly stacked
				for(i = 0; i < _layers.length; i++){
					tempLayer = _layers[i] as Sprite;
					
					if(tempLayer != null){
						_container.setChildIndex(tempLayer, Math.min(i, _container.numChildren - 1));
					}
				}
				tempLayer = null;
			}
			
			return _layers[layer] as DisplayObjectContainer;
		}
		
		public function getTransitionForLayer(layer:uint = LAYER_DEFAULT):String{
			if(layer > LAYER_POPUPS)
				return null;
			
			return _transitions[layer];
		}
		
		public function setTranstitionForLayer(transitionType:String, layer:uint = LAYER_DEFAULT):void{
			if(layer > LAYER_POPUPS)
				return;
			
			if(_valid_transitions.indexOf(transitionType) < 0){
				log('Invalid transition type, please use the constants provided');
				return;
			}
			
			_transitions[layer] = transitionType;			
		}
		
		/**
		 * Get the current page at the default layer.
		 *  
		 * @return 
		 */		
		public function get currentPage():DisplayObject{
			return getPageAtLayer(LAYER_DEFAULT);
		}
		
		/**
		 * Get the current page at a specified layer
		 *  
		 * @param layer
		 * @return 
		 */		
		public function getPageAtLayer(layer:uint = LAYER_DEFAULT):DisplayObject{
			if(!_container)
				throw new Error('Paging has no container: please set container property to a non-null value');				
			
			if(layer > LAYER_POPUPS)
				return null;
			
			// vars
			var layerContainer:DisplayObjectContainer, page:DisplayObject;
			
			layerContainer = getLayer(layer);
			
			if(layerContainer.numChildren == 0){
				return null;
			}
			
			// page at index 0 is *the* page to return (pages at higher indices are probably transitioning at this point)
			page = layerContainer.getChildAt(0);
			
			return page;
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