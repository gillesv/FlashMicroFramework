package framework.paging
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PagingLayer extends EventDispatcher
	{
		public var container:DisplayObjectContainer;
		
		private var _transition:String = Paging.TRANSITION_IN_OUT;
		
		public function PagingLayer(container:DisplayObjectContainer, target:IEventDispatcher=null)
		{
			super(target);
			
			this.container = container;
		}
		
		public function gotoPage(page:DisplayObject):void{
			
		}
		
		public function closePage():void{
			
		}
		
		public function disable():void{
			container.mouseChildren = container.mouseEnabled = false;
		}
		
		public function enable():void{
			container.mouseChildren = container.mouseEnabled = true;
		}
		
		/**
		 * What kind of transition should the layer operate?
		 */		
		public function getTransition():String{
			return _transition;
		}
		public function setTransition(value:String):void{
			if(Paging.TRANSITIONS.indexOf(value) < 0)
				throw new Error('Invalid transition-type: ' + value);
			
			_transition = value;
		}
		
		/**
		 * The highest page in the stack 
		 */		
		public function get currentPage():DisplayObject{
			if(container.numChildren == 0){
				return null;
			}
			
			var page:DisplayObject;
			
			// page at highest index is *the* page to return (pages at lower indices are probably transitioning at this point)
			page = container.getChildAt(container.numChildren - 1);
			
			return page;
		}
	}
}