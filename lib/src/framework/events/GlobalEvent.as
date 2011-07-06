package framework.events
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{		
		public function GlobalEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event{
			return new GlobalEvent(type);
		}
		
		public function addListener(listener:Function, useWeakReference:Boolean = true):void{
			GlobalEventDispatcher.instance.addEventListener(type, listener, false, 0, useWeakReference);
		}
		
		public function removeListener(listener:Function):void{
			GlobalEventDispatcher.instance.removeEventListener(type, listener);
		}
		
		public function hasEventListener():Boolean{
			return GlobalEventDispatcher.instance.hasEventListener(type);
		}
				
		public function dispatch():Boolean{
			return GlobalEventDispatcher.instance.dispatchEvent(this);
		}
	}
}