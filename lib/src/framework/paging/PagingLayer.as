package framework.paging
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class PagingLayer extends DisplayObjectContainer implements IPagingLayer
	{
		private var _previous_page:DisplayObject;
		
		protected var _transition_type:String = PagingTransitionTypes.TRANSITION_IN_OUT;
		protected var _transition_controller:ITransitionController;
		
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
			
			// add it to the displaylist
			addChild(page);
			
			switch(_transition_type){
				
				case PagingTransitionTypes.TRANSITION_IN:
					
					// remove old page, if any
					
					break;
				
				case PagingTransitionTypes.TRANSITION_IN_OUT:
					
					break;
				
				case PagingTransitionTypes.TRANSITION_CROSSFADE:
					
					break;
			}	
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
	}
}