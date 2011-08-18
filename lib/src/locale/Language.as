package locale
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import locale.events.MultiLangEvent;
	
	public class Language extends EventDispatcher implements IEventDispatcher
	{
		public var id:String;
		public var isLoaded:Boolean = false;
		
		private var keys:Object = {};
		private var sectionUrls:Object = {};
		
		private var _dispatcher:IEventDispatcher;
		
		private var xmlUrl:URLRequest;
		
		public function Language(id:String, xml:*)
		{
			this.id = id;
			
			if(xml as XML){
				parseXML(xml);
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
		
		/**
		 * Parse the Language XML file
		 * 
		 * @param xml
		 */		
		public function parseXML(xml:XML):void{
			keys = {};
			sectionUrls = {};
			
			// loose keys
			for(var i:int = 0; i < xml.children().length(); i++){
				var node:XML = xml.children()[i];
				
				switch(node.name().toString().toLowerCase()){
					case "key":
							parseKey(node);
						break;
					case "section":
							parseSection(node);
						break;
				}
			}
			
			dispatchEvent(new MultiLangEvent(MultiLangEvent.LANG_LOADED));
		}
		
		/**
		 * Parse a single key 
		 *  
		 * @param xml
		 * @param section
		 */		
		protected function parseKey(xml:XML, section:String = ""):void{
			var key:Key = new Key();
			
			key.fromXML(xml);
			
			var path:String = key.id;
			
			if(section != "")
				path = section + "/" + path;
			
			keys[path] = key;
		}
		
		/**
		 * Parse a section
		 *  
		 * @param xml
		 */		
		protected function parseSection(xml:XML):void{
			var sectionId:String = xml.@id;
			
			sectionUrls[sectionId] = xml.@url;
			
			for each(var key:XML in xml.key){
				parseKey(key, sectionId);
			}
		}
		
		/**
		 * XML Loaded Event Handler
		 */		
		private function on_xml_loaded(evt:Event):void{
			var xml:XML = new XML(URLLoader(evt.target).data);
			parseXML(xml);
		}
		
		private function on_xml_load_error(evt:IOErrorEvent):void{
			trace("Couldn't load XML from URL " + xmlUrl.url);
		}
		
		private function on_xml_load_security_error(evt:SecurityErrorEvent):void{
			trace("Couldn't load XML from URL " + xmlUrl.url + " - Security Error: " + evt.text);
		}
		
		/**
		 * Stop dispatching events
		 */		
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
			var key:Key;
			
			var truncatedPath:String = (path.split("/").length > 2) ? path.split("/").slice(0, 2).join("/") : path;
			
			if(path.indexOf("/") < 0)
				key = keys[path] as Key;
			else
				key = keys[truncatedPath] as Key;
			
			if(!key){
				key = new Key();
				
				if(path.indexOf("/") < 0){
					key.id = path;
				}else{
					var parts:Array = path.split("/");
					
					for(var i:int = 0; i < parts.length; i++){
						var part:String = parts[i];
						
						switch(i){
							case 0:
								key.section = part;
								break;
							case 1:
								key.id = part;
								break;
							case 2:
								key.content = part;
								key.comment = part;
								break;
						}	
					}
				}
				
				keys[truncatedPath] = key;				
			}
			
			return key.content;
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