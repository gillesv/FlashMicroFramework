package locale
{
	import core.S;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	
	import framework.events.GlobalEvent;
	
	import locale.events.MultiLangEvent;
	
	public class MultiLang implements IEventDispatcher
	{
		
		public var DEFAULT_XML_FILENAME_PREFIX:String = "flashCopy_";
		
		private var _lang:String;
		private var _languages:Object = {};
		private var _selectedLanguage:Language;
		
		private static var _instance:MultiLang;
		
		private var _isEditing:Boolean = false;
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
			isEditing = false;
			
			if(_lang != value){
				if(_languages[value] == null){
					throw new Error('Language ' + value + ' not found.');
					
					return;
				}
				
				if(_selectedLanguage)
					_selectedLanguage.deactivate();
				
				_lang = value;
				
				_selectedLanguage = _languages[_lang] as Language;
				_selectedLanguage.activate(this);		
			}
		}
		
		/**
		 * Add a Language object to the cache.
		 *  
		 * @param value 
		 */		
		public function addLanguage(value:Language):void{
			_languages[value.id] = value;
			
			if(!lang)
				lang = value.id;
		}
		
		/**
		 * Returns an array of all Language objects 
		 */		
		public function get languages():Array{
			var arr:Array = [];
			
			for(var s:String in _languages){
				arr.push(_languages[s]);
			}
			
			return arr;
		}
		
		/**
		 * Returns an array of language-identifier strings (can be used to set the active language) 
		 */		
		public function get languageIds():Array{
			var arr:Array = [];
			
			for(var s:String in _languages){
				arr.push(s);
			}
			
			return arr;
		}
		
		/**
		 * Get a translation for a path
		 *  
		 * @param path The string under which the translation can be found: i.e 'home/title' or 'about/content'
		 * @return The value for said key, or the path
		 * 
		 */		
		public function getStringForPath(path:String):String{
			if(_selectedLanguage)
				return _selectedLanguage.getStringForPath(path);
			
			return path;
		}
		
		/**
		 * Store a translation value for a path.
		 *  
		 * @param value The value you want to associate with the provided path
		 * @param path The string under which the translation can be found: i.e 'home/title' or 'about/content'
		 * 
		 */		
		public function setStringForPath(value:String, path:String, comment:String = ""):void{
			if(_selectedLanguage)
				_selectedLanguage.setStringForPath(value, path, comment);
		}
		
		/**
		 * Is there a valid value for the provided path?
		 *  
		 * @param path The string under which the translation can be found: i.e 'home/title' or 'about/content'
		 * @return true if there's a custom value for the path, false if path and returned value are identical.
		 * 
		 */		
		public function pathExists(path:String):Boolean{
			if(_selectedLanguage)
				return _selectedLanguage.pathExists(path);
			
			return false;
		}
		
		/**
		 * Return a generated XML file of the current contingent of localized copy
		 *  
		 * @return formatted XML
		 */		
		public function toXML():XML{
			if(_selectedLanguage)
				return _selectedLanguage.toXML();
			
			return null;
		}
		
		/**
		 *  
		 */		
		public function saveXML():void{
			try{
				var output:XML = toXML();
				
				// insert CDATA
				for each(var key:XML in output..key){
					for each(var child:XML in key.children()){
						if(child.children().length() > 0){
							child.setChildren("<![CDATA[" + (child.toString()) + "]]>");
						}
					}
				}
				
				var utfbytes:ByteArray = new ByteArray();
				
				// encode everything properly
				var string:String = '<?xml version="1.0" encoding="utf-8"?>\n' + output.toXMLString();
				string = htmlUnescape(string.split("<").join("&lt;").split(">").join("&gt;"));
				
				utfbytes.writeUTFBytes(string);
				
				//var filename:String = Language(_languages[lang]).filename;
				//var filename:String = "translation_" + lang + ".xml";
				var filename:String = DEFAULT_XML_FILENAME_PREFIX + _selectedLanguage.id + ".xml";
				
				var fileref:FileReference = new FileReference();
				fileref.addEventListener(Event.SELECT, on_save_file_select);
				
				fileref.save(utfbytes, filename);
				
				function on_save_file_select(evt:Event):void{
					// it's saved.	
				}
				
				function htmlUnescape(str:String):String{
					return new XMLDocument(str).firstChild.nodeValue;
				}
			}catch(err:Error){
				trace("MultiLang Error: couldn't export XML");
				trace(err.message);
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get isReady():Boolean{
			if(_selectedLanguage)
				return _selectedLanguage.isLoaded;
			
			return false;
		}
		
		/**
		 * Is the locale-framework in edit-mode? 
		 */		
		public function get isEditing():Boolean{
			return _isEditing;
		}

		public function set isEditing(value:Boolean):void{
			if(value)
				startEditing();
			else
				stopEditing();
		}
		
		/**
		 * Begin editing copy 
		 */		
		public function startEditing():void{
			if(!_isEditing){
				_isEditing = true;
				dispatchEvent(new MultiLangEvent(MultiLangEvent.BEGIN_EDIT, lang));
			}
		}
		
		/**
		 * End editing copy 
		 */	
		public function stopEditing():void{
			if(_isEditing){
				_isEditing = false;
				dispatchEvent(new MultiLangEvent(MultiLangEvent.END_EDIT, lang));
			}
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
				dispatchEvent(new MultiLangEvent(MultiLangEvent.DYNAMIC_VALUE_CHANGED, lang));
			}catch(err:Error){
				trace("Couldn't convert value for id '" + id + "' to String");
			}
		}
		
		public function getDynamicValueForId(id:String):String{
			if(_dynamicValues[id])
				return _dynamicValues[id].toString();
			
			return "";
		}
		
		public function existsDynamicValueForId(id:String):Boolean{
			return (getDynamicValueForId(id) != "");
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