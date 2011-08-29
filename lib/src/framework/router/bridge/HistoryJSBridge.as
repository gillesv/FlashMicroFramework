package framework.router.bridge
{
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	
	import framework.router.Router;

	public class HistoryJSBridge
	{
		public const INIT_DELAY:int = 200;
		
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
		
		public function kill():void{
			if(externalInterfaceIsAvailable){
				ExternalInterface.addCallback("changeState", null);
			}
		}
		
		protected function on_state_change(path:String):void{
			if(_path != path){
				_path = path;
				router.route(path);
			}
		}
		
		protected var _path:String;
		
		public function set state(path:String):void{
			if(externalInterfaceIsAvailable){
				ExternalInterface.call("flashPushHistoryState", path);
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

	}
}