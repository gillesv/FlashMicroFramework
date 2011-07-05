package
{
	import framework.events.GlobalEventDispatcher;

	public function addGlobalEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
		GlobalEventDispatcher.instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
}