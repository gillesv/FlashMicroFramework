package framework.router.bridge
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	
	import framework.router.Router;
	
	/** 
	 * @author gillesv
	 * 
	 * A bridge between the Router and a History.js powered deeplinking system. 
	 */	
	public class HistoryJSBridge extends EventDispatcher
	{
		public const INIT_DELAY:int = 200;
		
		private var _title:String = "HistoryJSBridge Title";
		
		private var _router:Router;
		
		public function HistoryJSBridge(router:Router){
			this._router = router;
		}
		
		public function init():void{
			if(externalInterfaceIsAvailable){
				ExternalInterface.addCallback("changeState", on_state_change);
				
				setTimeout(function():void{
					ExternalInterface.call("initFlashHistoryBridge");
				}, INIT_DELAY);
			}else{
				setTimeout(function():void{
					on_state_change("");
				}, INIT_DELAY);
			}
		}
		
		/**
		 * Remove callbacks 
		 */		
		public function kill():void{
			if(externalInterfaceIsAvailable){
				ExternalInterface.addCallback("changeState", null);
			}
		}
		
		private var _firstCallback:Boolean = true;
		
		/**
		 * ExternalInterface callback
		 *  
		 * @param path
		 * @param title
		 * 
		 */		
		protected function on_state_change(path:String, title:String = ''):void{
			log(path);
			if(_path != path){
				_path = path;
				dispatchEvent(new Event(Event.CHANGE));
				
				router.route(path);
				
				if(title != '' && title != null)
					_title = title;
				
				if(_firstCallback){
					dispatchEvent(new Event(Event.INIT));
					
					_firstCallback = false;
				}
			}
		}
		
		/**
		 * Set the history state of the document and its title simultaneously
		 *  
		 * @param path
		 * @param title
		 */		
		public function setState(path:String, title:String = null):void{
			if(title != null)
				this._title = title;
			
			state = path;
		}
		
		protected var _path:String;
		
		/**
		 * Get or set the document's history state 
		 */		
		public function set state(path:String):void{
			if(externalInterfaceIsAvailable){
				ExternalInterface.call("flashPushHistoryState", path, title);
			}else{
				on_state_change(path);
			}
		}
		public function get state():String{
			if(_path)
				return _path;
			
			return "";
		}
		
		public function get router():Router{
			return _router;
		}
		
		public function get externalInterfaceIsAvailable():Boolean{
			return (ExternalInterface.available && Capabilities.playerType.toLowerCase() != "external");
		}
		
		/**
		 * Get or set the document's title 
		 */		
		public function get title():String{
			return _title;
		}
		public function set title(value:String):void{
			_title = value;
			
			if(externalInterfaceIsAvailable){
				ExternalInterface.call("flashSetTitle", _title);
			}
		}


	}
}