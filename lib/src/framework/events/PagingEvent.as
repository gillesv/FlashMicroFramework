package framework.events
{
	import flash.events.Event;
	
	public class PagingEvent extends GlobalEvent
	{
		public static const PAGE_CHANGING:String = "pageChanging";	// transition start
		public static const PAGE_CHANGED:String = "pageChanged";	// transition ended
		public static const PAGE_CLOSING:String = "pageClosing";	// transition start
		public static const PAGE_CLOSED:String = "pageClosed";		// transition ended
		
		public var page:*;
		public var layer:uint;
		
		public function PagingEvent(type:String, page:* = null, layer:uint = 1)
		{
			super(type);
			this.page = page;
			this.layer = layer;
		}
		
		override public function clone():Event{
			return new PagingEvent(type, page, layer);
		}
	}
}