package framework.paging.pages
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import framework.paging.IPage;
	import framework.paging.IPageExternal;
	import framework.paging.ITransitionController;
	import framework.paging.controllers.DefaultTransitionController;
	
	public class ExternalPage extends Loader implements IPageExternal
	{
		private var _id:String;
		private var _url:String;
		private var _params:*;
		
		private var _loaded:Boolean = false;
		
		private var _page:DisplayObject;
		private var _iPage:IPage;
		
		private var _controller:ITransitionController;
		
		public function ExternalPage(url:String, id:String){
			super();
			
			this._url = url;
			this._id = id;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function setup(params:*=null):void{
			this._params = params;
		}
		
		/**
		 * Loads the external swf 
		 */		
		public function init():void{
			// begin loading
			contentLoaderInfo.addEventListener(Event.COMPLETE, on_loaded);
			contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, on_progress);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, on_load_error);
			
			load(new URLRequest(_url));
		}
		
		public function kill():void{
			cancelLoad();			
			_controller = null;
			
			if(_iPage){
				_iPage.kill();
			}
		}
		
		/** loading **/
		
		protected function cancelLoad():void{
			contentLoaderInfo.removeEventListener(Event.COMPLETE, on_loaded);
			contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, on_progress);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, on_load_error);
		}
		
		/** events **/
		
		protected function on_loaded(evt:Event):void{
			cancelLoad();
			
			this._page = contentLoaderInfo.content as DisplayObject;
			
			_loaded = true;
			
			if(this._page as IPage){
				_iPage = IPage(this._page);
				
				if(_params){
					_iPage.setup(_params);
				}
				
				_iPage.init();
			}

			if(_intro_callback != null){
				animateIn(_intro_callback, _intro_callbackParams);
			}
		}	
		
		protected function on_progress(evt:ProgressEvent):void{
			log("loading page " + id + " progress: " + evt.bytesLoaded + " / " + evt.bytesTotal);
		}
		
		protected function on_load_error(evt:IOErrorEvent):void{
			cancelLoad();
			
			log(evt.text);
		}
		
		/** transitions **/
		
		public function setupIntro():void{
			visible = false;
		}
		
		public function setupOutro():void{
			if(canAnimateOut){
				_iPage.setupOutro();
			}
		}
		
		private var _intro_callback:Function;
		private var _intro_callbackParams:*;
		
		public function animateIn(callback:Function, callbackParams:*):void{
			this._intro_callback = callback;
			this._intro_callbackParams = callbackParams;
			
			if(_loaded){
				visible = true;
				
				if(_iPage && _iPage.canAnimateIn){
					_iPage.setupIntro();
					_iPage.animateIn(callback, callbackParams);
				}else{
					defaultController.setupIntro(_page);
					defaultController.animatePageIn(_page, callback, callbackParams);
				}
			}
		}
				
		public function animateOut(callback:Function, callbackParams:*):void{
			if(_loaded){
				_iPage.animateOut(callback, callbackParams);
			}else{
				// prevent loading
				cancelLoad();
				
				callback.apply(null, callbackParams);
			}
		}
		
		public function get canAnimateIn():Boolean{
			return true;
		}
		
		public function get canAnimateOut():Boolean{
			if(_iPage){
				return _iPage.canAnimateOut;
			}
			
			return false;
		}
		
		public function get defaultController():ITransitionController{
			if(!_controller){
				_controller = new DefaultTransitionController();
			}
			
			return _controller;
		}
		
		public function set defaultController(value:ITransitionController):void{
			_controller = value;
		}
	}
}