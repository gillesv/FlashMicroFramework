package locale
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import framework.events.GlobalEvent;
	
	public class MultiLang implements IEventDispatcher
	{
		
		private var _lang:String;
		private var languages:Object = {};
		private var selectedLanguage:Language;
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
			if(_lang != value){
				if(languages[value] == null){
					throw new Error('Language ' + value + ' not found.');
					
					return;
				}
				
				if(selectedLanguage)
					selectedLanguage.deactivate();
				
				_lang = value;
				
				selectedLanguage = languages[_lang] as Language;
				selectedLanguage.activate(this);		
			}
		}
		
		/**
		 * Add a Language object to the cache.
		 *  
		 * @param value 
		 */		
		public function addLanguage(value:Language):void{
			languages[value.id] = value;
			
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
			if(selectedLanguage)
				return selectedLanguage.getStringForPath(path);
			
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
			selectedLanguage.setStringForPath(value, path);
		}
		
		/**
		 * Is there a valid value for the provided path?
		 *  
		 * @param path The string under which the translation can be found: i.e 'home/title' or 'about/content'
		 * @return true if there's a custom value for the path, false if path and returned value are identical.
		 * 
		 */		
		public function pathExists(path:String):Boolean{
			if(selectedLanguage)
				return selectedLanguage.pathExists(path);
			
			return false;
		}
		
		private var _dynamicValues:Object = {};
		
		/**
		 * Set a dynamic value to be inserted whenever it's id is referenced within square brackets ([...]) inside of text.
		 * e.g the following text: "There have been [amount] visitors" 
		 * If you then call MultiLang.instance.setDynamicValue("amount", 100), all labels that contain the following text will update to read "There have been 100 visitors"
		 *  
		 * @param id	the unique id
		 * @param value the object that will be inserted in that id's place in rendered text
		 * 
		 */		
		public function setDynamicValue(id:String, value:*):void{
			try{
				_dynamicValues[id] = value.toString();
				
				// dispatch event
			}catch(err:Error){
				trace("Couldn't convert value for id '" + id + "' to String");
			}
		}
		
		public function getDynamicValueForId(id:String):String{
			if(_dynamicValues[id])
				return _dynamicValues[id].toString();
			
			return "";
		}
		
		
		/**
		 * IEventDispatcher 
		 */		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(evt:Event):Boolean{
			if(evt as GlobalEvent)
				GlobalEvent(evt).dispatch();
			
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