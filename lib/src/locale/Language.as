package locale
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Language extends EventDispatcher implements IEventDispatcher
	{
		public var id:String;
		public var xml:XML;
		public var isLoaded:Boolean = false;
		
		private var _dispatcher:IEventDispatcher;
		
		private var xmlUrl:URLRequest;
		
		public function Language(id:String, xml:*)
		{
			this.id = id;
			
			if(xml as XML){
				this.xml = xml;
				isLoaded = true;
			}else if(xml as String){
				xmlUrl = new URLRequest(xml.toString());
			}else if(xml as URLRequest){
				xmlUrl = xml as URLRequest;
			}
		}
		
		/**
		 * Public Interface 
		 */		
		
		public function activate(dispatcher:IEventDispatcher):void{
			_dispatcher = dispatcher;
						
			if(isLoaded){
				
			}else{
				if(xmlUrl){
					var loader:URLLoader = new URLLoader();
					loader.addEventListener(Event.COMPLETE, on_xml_loaded);
					loader.addEventListener(IOErrorEvent.IO_ERROR, on_xml_load_error);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, on_xml_load_security_error);
					loader.load(xmlUrl);
					
				}else{
					throw new Error("No XML found for language " + id);
				}
			}
		}
		
		private function on_xml_loaded(evt:Event):void{
			var xml:XML = new XML(URLLoader(evt.target).data);
			
			//trace(xml.toXMLString());
		}
		
		private function on_xml_load_error(evt:IOErrorEvent):void{
			trace("Couldn't load XML from URL " + xmlUrl.url);
		}
		
		private function on_xml_load_security_error(evt:SecurityErrorEvent):void{
			trace("Couldn't load XML from URL " + xmlUrl.url + " - Security Error: " + evt.text);
		}
		
		public function deactivate():void{
			_dispatcher = null;
		}
		
		/**
		 * Get a translation for a path
		 *  
		 * @param path The string under which the translation can be found: i.e 'home/title' or 'about/content'
		 * @return The value for said key, or the path
		 * 
		 */		
		public function getStringForPath(path:String):String{
			return path;
		}
		
		/**
		 * Store a translation value for a path.
		 *  
		 * @param value The value you want to associate with the provided path
		 * @param path The string under which the translation can be found: i.e 'home/title' or 'about/content'
		 * 
		 */		
		public function setStringForPath(value:String, path:String):void{
			//
		}
		
		/**
		 * Is there a valid value for the provided path?
		 *  
		 * @param path The string under which the translation can be found: i.e 'home/title' or 'about/content'
		 * @return true if there's a custom value for the path, false if path and returned value are identical.
		 * 
		 */		
		public function pathExists(path:String):Boolean{
			return path == getStringForPath(path);
		}
		
		/**
		 * IEventDispatcher 
		 */		
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			if(_dispatcher)
				_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			else
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function dispatchEvent(evt:Event):Boolean{
			if(_dispatcher)
				return _dispatcher.dispatchEvent(evt);
			
			return super.dispatchEvent(evt);
		}
		
		override public function hasEventListener(type:String):Boolean{
			if(_dispatcher)
				return _dispatcher.hasEventListener(type);
			
			return super.hasEventListener(type);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			if(_dispatcher)
				_dispatcher.removeEventListener(type, listener, useCapture);
			else
				super.removeEventListener(type, listener, useCapture);
		}
		
		override public function willTrigger(type:String):Boolean{
			if(_dispatcher)
				return _dispatcher.willTrigger(type);
			return super.willTrigger(type);
		}
	}
}