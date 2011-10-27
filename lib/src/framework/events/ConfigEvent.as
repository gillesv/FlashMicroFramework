package framework.events
{
	import flash.events.Event;

	public class ConfigEvent extends GlobalEvent
	{
		public static const CONFIG_LOADED:String = "configLoaded";
		
		public function ConfigEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event{
			return new ConfigEvent(type);
		}
	}
}