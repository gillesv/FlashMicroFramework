package locale
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MultiLang implements IEventDispatcher
	{
		
		private var _lang:String;
		private var languages:Object = {};
		private static var _instance:MultiLang;
		
		private var _dispatcher:EventDispatcher;
		
		/**
		 * Locale Controller 
		 */		
		public function MultiLang()
		{
			super();
			
			_dispatcher = new EventDispatcher();
		}
		
		public static function get instance():MultiLang{
			if(!_instance){
				_instance = new MultiLang();
			}
			return _instance;
		}
		
		/**
		 * PUBLIC INTERFACE 
		 */		
		
		/**
		 * The currently selected language identifier. 
		 */		
		public function get lang():String{
			return _lang;
		}
		public function set lang(value:String):void{
			if(languages[value] == null){
				throw new Error('Language ' + value + ' not found.');
				
				return;
			}
			
			_lang = value;
		}
		
		/**
		 * Add a Language object to the cache.
		 *  
		 * @param value 
		 */		
		public function addLanguage(value:Language):void{
			languages[value.id] = languages;
			
			if(!lang)
				lang = value.id;
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
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(evt:Event):Boolean{
			return _dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean{
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean{
			return _dispatcher.willTrigger(type);
		}
	}
}