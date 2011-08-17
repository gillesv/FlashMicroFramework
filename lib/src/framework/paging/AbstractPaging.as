package framework.paging
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AbstractPaging extends EventDispatcher
	{
		public function AbstractPaging(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function gotoPage(pageId:String, request:*, data:*):void{
			// generate new page
			
			// transition out the old page (if applicable)
			
			// preload any assets...
			
			// transition in new page
			
			// complete
		}
	}
}