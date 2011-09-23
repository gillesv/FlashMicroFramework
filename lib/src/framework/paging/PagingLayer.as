package framework.paging
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class PagingLayer extends DisplayObjectContainer implements IPagingLayer
	{
		private var _previous_page:DisplayObject;
		
		private var _isTransitioning:Boolean = false;
		private var transitionQueue:Array = [];
		
		
		protected var _transition_type:String = PagingTransitionTypes.TRANSITION_IN_OUT;
		protected var _transition_controller:ITransitionController = new DefaultTransitionController();
		
		protected var _target:IEventDispatcher;
		
		public function PagingLayer(target:IEventDispatcher = null){
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
				
				case PagingTransitionTypes.TRANSITION_IN:
					// remove the previous page
					kill_page(_previous_page);
					
					// init & animate the new page
					if(init_page(page) as IPage && IPage(page).canAnimateIn){
						transitionIn = IPage(page).animateIn;
						transitionInParams = [on_page_added, null];
					}else{
						// no special powers, send it to the controller
						transitionIn = transitionController.animatePageIn;
						transitionInParams = [page, on_page_added, null];
					}
					
					// apply the transition
					transitionIn.apply(null, transitionInParams);
					
					break;
				
				case PagingTransitionTypes.TRANSITION_IN_OUT:
					
					break;
				
				case PagingTransitionTypes.TRANSITION_CROSSFADE:
					
					break;
			}	
			
			_previous_page = page;
		}
		
		protected function on_page_added():void{
			// dispatch events?
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
			switch(_transition_type){
				
				case PagingTransitionTypes.TRANSITION_IN:
					
					break;
				
				case PagingTransitionTypes.TRANSITION_IN_OUT:
					
					break;
				
				case PagingTransitionTypes.TRANSITION_CROSSFADE:
					
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

	}
}