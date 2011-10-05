package framework.paging
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import framework.events.PagingEvent;
	
	public class PagingLayer extends Sprite implements IPagingLayer
	{
		private var _previous_page:DisplayObject;
		
		private var _isTransitioning:Boolean = false;
		private var transitionQueue:Array = [];
		
		protected var _transition_type:String = PagingTransitionTypes.TRANSITION_IN;
		protected var _transition_controller:ITransitionController = new DefaultTransitionController();
		
		protected var _index:uint = 0;
		protected var _target:IEventDispatcher;
		
		public function PagingLayer(index:uint, target:IEventDispatcher = null){
			this._index = index;
			this._target = target;
		}
		
		/******* IEventDispatcher target rerouting block ********/
		
		override public function dispatchEvent(event:Event):Boolean{
			if(_target)
				return _target.dispatchEvent(event);	// Allow events to be rerouted through the parent Paging class
			
			return super.dispatchEvent(event);
		}
		
		/******** SHOW/REMOVE PAGE *********/
		
		public function addPage(page:DisplayObject):void{
			if(!page){
				log("addPage Error: page is null");
				return;
			}
			
			if(isTransitioning){
				transitionQueue.push(page);
				return;
			}
			
			isTransitioning = true;
			
			// method references used for transitioning
			var transitionIn:Function, transitionOut:Function;
			var transitionInParams:Array, transitionOutParams:Array;
			
			switch(_transition_type){
				case PagingTransitionTypes.TRANSITION_IN_OUT:
					// init & animate the new page
					if(init_page(page) as IPage && IPage(page).canAnimateIn){
						IPage(page).setupIntro();
						transitionIn = IPage(page).animateIn;
						transitionInParams = [on_page_added, [page]];
					}else{
						// no special powers, send it to the controller
						transitionController.setupIntro(page);
						transitionIn = transitionController.animatePageIn;
						transitionInParams = [page, on_page_added, [page]];
					}
										
					if(_previous_page){
						if(_previous_page as IPage && IPage(_previous_page).canAnimateOut){
							IPage(_previous_page).setupOutro();
							transitionOut = IPage(_previous_page).animateOut; // callback, params
							transitionOutParams = [ on_page_removed, [ _previous_page, transitionIn, transitionInParams ] ];
						}else{
							transitionController.setupOutro(_previous_page);
							transitionOut = transitionController.animatePageOut; // page, callback, params
							transitionOutParams = [ _previous_page, on_page_removed, [ _previous_page, transitionIn, transitionInParams ] ];
						}
					}
					
					if(transitionOut != null){
						transitionOut.apply(null, transitionOutParams);
					}else{
						transitionIn.apply(null, transitionInParams);
					}
					
					break;
				case PagingTransitionTypes.TRANSITION_IN:
					// remove the previous page
					kill_page(_previous_page);
					
					// init & animate the new page
					if(init_page(page) as IPage && IPage(page).canAnimateIn){
						IPage(page).setupIntro();
						transitionIn = IPage(page).animateIn;
						transitionInParams = [on_page_added, [page]];
					}else{
						// no special powers, send it to the controller
						transitionController.setupIntro(page);
						transitionIn = transitionController.animatePageIn;
						transitionInParams = [page, on_page_added, [page]];
					}
					
					// apply the transition
					transitionIn.apply(null, transitionInParams);
					
					break;
				
				case PagingTransitionTypes.TRANSITION_CROSSFADE:
					// just do it simultaneously
					
					// init & animate the new page
					if(init_page(page) as IPage && IPage(page).canAnimateIn){
						IPage(page).setupIntro();
						transitionIn = IPage(page).animateIn;
						transitionInParams = [on_page_added, [page]];
					}else{
						// no special powers, send it to the controller
						transitionController.setupIntro(page);
						transitionIn = transitionController.animatePageIn;
						transitionInParams = [page, on_page_added, [page]];
					}
					
					// kill and animate the old page, if any
					if(_previous_page){
						if(_previous_page as IPage && IPage(_previous_page).canAnimateOut){
							IPage(_previous_page).setupOutro();
							transitionOut = IPage(_previous_page).animateOut; // callback, params
							transitionOutParams = [ on_page_removed, [ _previous_page ] ];
						}else{
							transitionController.setupOutro(_previous_page);
							transitionOut = transitionController.animatePageOut; // page, callback, params
							transitionOutParams = [ _previous_page, on_page_removed, [ _previous_page ] ];
						}
					}
					
					transitionIn.apply(null, transitionInParams);
					
					if(transitionOut != null){
						transitionOut.apply(null, transitionOutParams);
					}
					
					break;
				
				case PagingTransitionTypes.TRANSITION_NONE:
					// remove previous page
					kill_page(_previous_page);
					
					// init next page
					init_page(page);
					
					// done & dispatch
					on_page_added(page);
					
					break;
			}	
			
			_previous_page = page;
		}
				
		protected function on_page_added(page:DisplayObject):void{
			// dispatch events?
			dispatchEvent(new PagingEvent(PagingEvent.PAGE_CHANGED, page, index));
			
			// stop transitioning
			isTransitioning = false;
			
			if(transitionQueue.length > 0){
				addPage(transitionQueue.shift() as DisplayObject);
			}
		}
		
		protected function on_page_removed(page:DisplayObject, callback:Function = null, callbackParams:Array = null):void{
			dispatchEvent(new PagingEvent(PagingEvent.PAGE_CLOSED, kill_page(page), index));
			
			if(callback != null){
				callback.apply(null, callbackParams);
			}
		}
		
		/**
		 * Add the page to the displaylist and init it, if supported
		 *  
		 * @param page
		 * @return 
		 * 
		 */		
		protected function init_page(page:DisplayObject):DisplayObject{
			addChild(page);
			
			if(page as IPage){
				IPage(page).init();
			}
			
			return page;
		}
		
		public function removePage():void{
			var child:DisplayObject;
			
			switch(_transition_type){
				case PagingTransitionTypes.TRANSITION_IN:
					while(numChildren > 0){
						child = kill_page(getChildAt(0));
					}
					
					dispatchEvent(new PagingEvent(PagingEvent.PAGE_CLOSED, child, index));
					return;
					
					break;
				
				case PagingTransitionTypes.TRANSITION_IN_OUT:
				case PagingTransitionTypes.TRANSITION_CROSSFADE:
					// show outro
					for(var i:int = 0; i < numChildren; i++){
						child = getChildAt(i);
												
						if(IPage(child) && IPage(child).canAnimateOut){
							IPage(child).animateOut(kill_page, [child]);
						}else{
							_transition_controller.animatePageOut(child, kill_page, [child]);
						}
					}
					
					break;
			}
		}
		
		protected function kill_page(page:DisplayObject):DisplayObject{
			if(page == null)
				return null;
			
			if(page.parent == this){
				removeChild(page);
			}
			
			if(page as IPage){
				IPage(page).kill();
			}
			
			dispatchEvent(new PagingEvent(PagingEvent.PAGE_CLOSED, page, index));
			
			return page;
		}
		
		/***** ENABLE/DISABLE *****/
		
		public function enable():void{
			isEnabled = true;
		}
		
		public function disable():void{
			isEnabled = false;
		}
		
		public function get isEnabled():Boolean
		{
			return mouseEnabled;
		}
		
		public function set isEnabled(value:Boolean):void{
			mouseChildren = mouseEnabled = value;
		}
		
		/****** GET PAGE *******/
		
		public function get activePage():DisplayObject
		{
			if(numChildren > 0)
				return getChildAt(numChildren - 1);
			
			return null;
		}
		
		/**
		 * How should the transitions work? Choice between
		 * 
		 * 	PagingTransitionTypes.TRANSITION_IN : instantly remove previous page and only trigger intro-transitions
		 *  
		 */		
		public function get transitionType():String{
			return _transition_type;
		}
		public function set transitionType(value:String):void{
			if(PagingTransitionTypes.TRANSITIONS.indexOf(value) < 0)
				throw new Error('Invalid transition type: ' + value + '. Use one of the values provided in PagingTransitionTypes.');
			
			_transition_type = value;
		}
		
		public function get transitionController():ITransitionController{
			return _transition_controller;
		}
		public function set transitionController(value:ITransitionController):void{
			_transition_controller = value;
		}
		
		/**
		 * Is a transition in progress?
		 *  
		 * @return 
		 * 
		 */		
		public function get isTransitioning():Boolean
		{
			return _isTransitioning;
		}

		public function set isTransitioning(value:Boolean):void
		{
			_isTransitioning = value;
		}
		
		public function get index():uint{
			return _index;
		}
		
		public function get container():DisplayObjectContainer{
			return this;
		}

	}
}