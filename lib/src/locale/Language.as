package locale
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	
	public class Language
	{
		public var id:String;
		public var xml:XML;
		public var isLoaded:Boolean = false;
		
		private var xmlUrl:URLRequest;
		
		public function Language(id:String, xml:*)
		{
			this.id = id;
			
			if(xml as XML){
				this.xml = xml;
			}else if(xml as String){
				xmlUrl = new URLRequest(xml.toString());
			}else if(xml as URLRequest){
				xmlUrl = xml as URLRequest;
			}
		}
		
		public function activate(dispatcher:IEventDispatcher):void{
			
		}
	}
}