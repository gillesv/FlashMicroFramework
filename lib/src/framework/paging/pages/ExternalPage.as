package framework.paging.pages
{
	import flash.display.Loader;
	
	import framework.paging.IPage;
	
	public class ExternalPage extends Loader implements IPage
	{
		private var _id:String;
		private var _url:String;
		private var _params:*;
		
		public function ExternalPage(url:String, id:String){
			super();
			
			this._url = url;
			this._id = id;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function setup(params:*=null):void
		{
			this._params = params;
		}
		
		public function init():void{
			// begin loading
		}
		
		public function kill():void{
			
		}
		
		public function setupIntro():void{
			
		}
		
		public function setupOutro():void{
			
		}
		
		public function animateIn(callback:Function, callbackParams:*):void
		{
		}
		
		public function animateOut(callback:Function, callbackParams:*):void
		{
		}
		
		public function get canAnimateIn():Boolean
		{
			return false;
		}
		
		public function get canAnimateOut():Boolean
		{
			return false;
		}
	}
}