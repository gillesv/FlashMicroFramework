package framework.config
{
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import framework.events.ConfigEvent;

	public class Config
	{
		public static const SOURCE_XML:String = "xmlSource";
		public static const SOURCE_FLASHVAR:String = "flashVarSource";
		public static const SOURCE_QUERYSTRING:String = "queryStringSource";
		public static const SOURCE_FLASH_COOKIE:String = "flashCookieSource";
		
		public var filename:String = "default.xml";
		protected var xml:XML;
		
		private static var _instance:Config;
		
		private var _isLoaded:Boolean = false;
		private var stage:Stage;
		
		public function Config(){}
		
		public static function get instance():Config{
			if(!_instance)
				_instance = new Config();
			
			return _instance;
		}
		
		public function init(stageRef:Stage):void{
			if(!_isLoaded){
				this.stage = stageRef;
				
				var url:String = "";
				
				var loaderinfo:LoaderInfo = stage.loaderInfo;
				
				var hu:HostURL = new HostURL(loaderinfo);
				_globalURL = hu.baseURL;
				
				var _swfURL:String = url = loaderinfo.url.split("/", loaderinfo.url.split("/").length - 1).join("/") + "/";
				
				if(filename.indexOf(".xml") < 0)
					filename += ".xml";
				
				url+= filename;
				
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, on_xml_loaded);
				loader.addEventListener(IOErrorEvent.IO_ERROR, on_xml_load_error);
				loader.load(new URLRequest(url));
			}
		}
		
		protected function parseXML(xml:XML):void{
			this.xml = xml;
			
			_isLoaded = true;
			
			new ConfigEvent(ConfigEvent.CONFIG_LOADED).dispatch();
		}
		
		private function on_xml_loaded(evt:Event):void{
			try{
				var xml:XML = new XML(URLLoader(evt.target).data);
				parseXML(xml);
			}catch(err:Error){
				log("Fatal error: couldn't parse " + filename);
			}
		}
		
		private function on_xml_load_error(evt:IOErrorEvent):void{
			log("Fatal error: couldn't load " + filename);
		}
		
		public function get assets():XML{
			return new XML(xml.assets);
		}
		
		public function getAssetURLForId(id:String):URLRequest{
			var url:String = xml.assets.asset.(@id == id).@url.toString();
			
			if(url.indexOf("http://") < 0 && url.indexOf("https://") < 0)
				url = globalURL + url;
			
			return new URLRequest(url);
		}
		
		public function get languages():XML{
			return new XML(xml.settings.languages);
		}
		
		public function getLanguageURLForId(id:String):URLRequest{
			var url:String = xml.languages.(@id == id).@url.toString();
			
			if(url.indexOf("http://") < 0 && url.indexOf("https://") < 0)
				url = globalURL + url;
			
			return new URLRequest(url);
		}
		
		public function get customSettings():XML{
			return new XML(xml.customSettings);
		}
		
		public function readVar(id:String):String{
			return null;
		}
		
		public function readVarByType(id:String, type:String):String{
			return null;
		}
		
		public function writeFlashCookie(id:String, value:String):void{
			
		}
		
		public function readFlashCookie(id:String):String{
			return readVarByType(id, SOURCE_FLASH_COOKIE);
		}
		
		private var _globalURL:String;
		
		public function get globalURL():String{
			if(xml){
				if(xml.settings.globalURL.toString() != ""){
					return xml.settings.globalURL.toString();
				}
			}
			
			if(_globalURL)
				return _globalURL;
			
			return "";
		}

		public function get isLoaded():Boolean{
			return _isLoaded;
		}

	}
}

import flash.display.LoaderInfo;
import flash.external.ExternalInterface;
import flash.net.URLVariables;
import flash.system.Capabilities;

internal class HostURL
{
	private var _sBaseURL:String = "../";
	private var _sBaseURLMAC:String = "..\\";
	
	private var _sBrowserURL:String = "";
	
	private var _sBrowserQueryString:String = "";
	private var _uvQueryParameters:URLVariables;
	
	private var _isLocal:Boolean = false;
	
	public function HostURL(loaderInfo:LoaderInfo):void {
		if(Capabilities.manufacturer == "Macintosh")
			_sBaseURL = _sBaseURLMAC;
		
		if(Capabilities.playerType == "Desktop"){
			_sBaseURL = "";
			_isLocal = true;
		}else{
			try {
				if(ExternalInterface.available) {
					_sBrowserURL = ExternalInterface.call("window.location.href.toString");
					_sBrowserQueryString = ExternalInterface.call("window.location.search.substring", 1);
					
					_sBaseURL = _sBrowserURL.split("#")[0]; // SWFAddress
					_sBaseURL = _sBaseURL.split("?")[0].substring(0, _sBaseURL.split("?")[0].lastIndexOf("/")) + "/";
				}
			} catch(e:Error) {
				_isLocal = true;
			}
		}
		
		if(_sBrowserQueryString && _sBrowserQueryString.length > 0) {
			try {
				
				if( _sBrowserQueryString.lastIndexOf("&") >= _sBrowserQueryString.length-1 )
					_sBrowserQueryString = _sBrowserQueryString.substr(0, _sBrowserQueryString.length - 1);
				
				_uvQueryParameters = new URLVariables(_sBrowserQueryString);
			} catch(e:Error) {
				// 
			}
		}
	}
	
	/**
	 * Setup different base URL
	 */
	public function set baseURL(value:String):void {
		_sBaseURL = value;
	}
	
	/**
	 * Get current URL
	 * 
	 * Returns 	String	Relative URL when working in Flash IDE ('../../' on WIN and '..\\..\\' on MAC)
	 */
	public function get baseURL():String {
		return _sBaseURL;
	}
	
	/**
	 * Get all query variables from browser URL
	 * 
	 * Returns 	URLVariables	Query variables
	 */
	public function get variables():URLVariables {
		return _uvQueryParameters;
	}
	
	/**
	 * Get query variable from browser URL (Alternative Method)
	 * 
	 * Returns 	String	Variable
	 */
	public function read(value:String):String {
		return _uvQueryParameters ? _uvQueryParameters[value] == undefined ? "" : _uvQueryParameters[value] : "";
	}
	
	/**
	 * Does a query variable exists in browser URL
	 * 
	 * Returns 	String	Variable
	 */
	public function exists(value:String):Boolean {
		return read(value).length > 0;
	}
	
	/**
	 * Check if given URL is a directory. If path is empty, the current baseURL is used.
	 * 
	 * Returns	Boolean	Is directory
	 */
	public function isDirectory(path:String = ""):Boolean {
		if (path.length == 0)
			path = baseURL;
		
		return (path.charAt(path.length - 1) == '/');
	}
}