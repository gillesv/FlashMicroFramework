package
{
	import framework.events.GlobalEventDispatcher;

	public function removeGlobalEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
		GlobalEventDispatcher.instance.removeEventListener(type, listener, useCapture);
	}
}