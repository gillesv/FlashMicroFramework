package framework.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class GlobalEventDispatcher extends EventDispatcher
	{
		public function GlobalEventDispatcher(param:SE)
		{
			if(!param)
				throw new Error("GlobalEventDispatcher is a Singleton, please do not call its constructor directly.");
		}
		
		private static var _instance:GlobalEventDispatcher;
		
		public static function get instance():GlobalEventDispatcher{
			if(!_instance)
				_instance = new GlobalEventDispatcher(new SE());
			return _instance;
		}
	}
}
internal class SE{}