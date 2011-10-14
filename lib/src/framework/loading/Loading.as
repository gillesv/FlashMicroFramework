package framework.loading
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class Loading
	{
		/**
		 * The root displayobject where the Loading framework will act upon. 
		 */		
		public var ui:Sprite;
		
		private var _isLoaderVisisble:Boolean = false;
		private var _preloader:MovieClip;
		private var _isBlocked:Boolean = false;
		
		/**
		 * Common use case:
		 * 
		 * Use as a component to block UI interaction and provide user feedback when the app 
		 * needs to preload something. 
		 * 
		 * This is NOT a bulk-loading-type system - this is merely a construct to ease the 
		 * creation of user-friendly preloading systems.
		 *  
		 */
		public function Loading(ui:Sprite){
			this.ui = ui;
		}
		
		/** Preloaders **/
		
		public function get preloader():MovieClip {
			return _preloader;
		}
		
		public function set preloader(value:MovieClip):void {
			_preloader = value;
		}
		
		public function showLoader():void{
			if(!_preloader){
				return;
			}				
			
			if(_isLoaderVisisble){
				return;
			}
			
			_preloader.visible = true;
			_isLoaderVisisble = true;
		}
		
		public function hideLoader():void{
			if(!_preloader){
				return;
			}
			
			if(!_isLoaderVisisble){
				return;
			}
			
			_preloader.visible = false;
			_isLoaderVisisble = false;
		}
		
		public function get isLoaderVisisble():Boolean{
			return _isLoaderVisisble;
		}

		public function set isLoaderVisisble(value:Boolean):void{
			if(value){
				showLoader();
			}else{
				hideLoader();
			}
		}
		
		/** UI Blocking **/
		
		public function block():void{
			if(_isBlocked){
				return;
			}
			
			ui.mouseChildren = ui.mouseEnabled = false;
			
			_isBlocked = true;
		}
		
		public function unblock():void{
			if(!_isBlocked){
				return;
			}
			
			ui.mouseChildren = ui.mouseEnabled = true;
			
			_isBlocked = false;
		}

		public function get isBlocked():Boolean{
			return _isBlocked;
		}

		public function set isBlocked(value:Boolean):void{
			if(value){
				block();
			}else{
				unblock();
			}
		}

		
		
		
	}
}