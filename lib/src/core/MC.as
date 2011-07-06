package core
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 
	 * @author gillesv
	 * 
	 * Replacement for BaseMovieClip: a lot easier to type into the base-class slot
	 *  
	 */	
	public class MC extends MovieClip
	{
		/**
		 * Boolean: has the init() method been called automatically before? 
		 */		
		protected var is_inited:Boolean = false;
		
		/**
		 * Easily overridable dimensions.
		 * 
		 * If you want a precise or self-calculated width or height for your movieclip, simply set these values and to all
		 * concerned, your sprite will measure exactly these values. 
		 */		
		protected var _width:Number = -1;
		protected var _height:Number = -1;
		
		/**
		 * The controller class for all special functionality 
		 */		
		public var controller:MCController;
		
		public function MC()
		{
			super();
			
			controller = new MCController(this, true);
			addEventListener(Event.ADDED_TO_STAGE, on_added);
		}
		
		/**
		 * This method gets called automatically once, and once only, when the sprite is added to stage, except when you manually override the is_inited property. 
		 * Use this method stub to initialize any stage-dependent functionality your component might possess. 
		 */		
		public function init():void{
			
		}
		
		/**
		 * This method gets called automatically when the sprite is removed from stage. 
		 * Use this stub to clean up after your component once it has been visually removed from the document (i.e. remove enterframes, etc...)
		 */		
		public function kill():void{
			
		}
		
		/**
		 * Remove all children in this Sprite's displaylist
		 */		
		public function empty():void{
			while(numChildren > 0)
				removeChildAt(0);
		}
		
		/********************/
		/**  composition   **/
		/********************/
		
		/**
		 * Play until the frame is reached, then optionally call a function.
		 *  
		 * @param frame		a frame number or label.
		 * @param callback	OPTIONAL a method to call when the frame is reached.
		 * 
		 */		
		public function playUntil(frame:Object, callback:Function = null, params:* = null, looping:Boolean = false):void{
			controller.playUntil(frame, callback, params, looping);
		}
		
		/**
		 * Play the animation in reverse. 
		 */		
		public function reverse():void{
			controller.reverse();
		}
		
		/**
		 * Reverse the animation until a frame is reached, then optionally call a function.
		 *  
		 * @param frame		a frame number or label.
		 * @param callback	OPTIONAL a method to call when the frame is reached.
		 * 
		 */		
		public function reverseUntil(frame:Object, callback:Function = null, params:* = null, looping:Boolean = false):void{
			controller.reverseUntil(frame, callback, params, looping);
		}
		
		public function goto(frame:Object, callback:Function = null, params:* = null, looping:Boolean = false):void{
			controller.goto(frame, callback, params, looping);
		}
		
		/**
		 * Go to the frame, then reverse the animation.
		 *  
		 * @param frame		a frame number or label.
		 * 
		 */		
		public function gotoAndReverse(frame:Object):void{
			controller.gotoAndReverse(frame);
		}
		
		// overrides
		override public function stop():void {
			super.stop();
			controller.isReversing = false;
		}
		
		override public function play():void {
			super.play();
			controller.isReversing = false;
		}
		
		override public function gotoAndStop(frame:Object, scene:String = null):void {
			super.gotoAndStop(frame, scene);
			controller.isReversing = false;
		}
		
		override public function gotoAndPlay(frame:Object, scene:String = null):void {
			super.gotoAndPlay(frame, scene);
			controller.isReversing = false;
		}		
		
		public function set currentFrame(value:int):void{
			gotoAndStop(value);
		}
		
		/********************/
		/**   properties   **/
		/********************/
		
		override public function get width():Number{
			if(_width > 0)
				return _width;
			
			return super.width;
		}
		
		override public function set width(value:Number):void{
			if(_width > 0)
				_width = value;
			else
				super.width = value;
		}
		
		override public function get height():Number{
			if(_height > 0)
				return _height;
			
			return super.height;
		}
		
		override public function set height(value:Number):void{
			if(_height > 0)
				_height = value;
			else
				super.height = value;
		}
		
		/********************/
		/** event handlers **/
		/********************/
		
		/**
		 * Event handler: gets called when the sprite is added to stage.
		 *  
		 * @param evt
		 * 
		 */		
		private function on_added(evt:Event):void{
			if(!is_inited){
				if(!controller){
					controller = new MCController(this, false);
				}

				controller.init();
				init();
								
				addEventListener(Event.REMOVED_FROM_STAGE, on_removed);
				removeEventListener(Event.ADDED_TO_STAGE, on_added);
				is_inited = true;
			}
			
		}
		
		/**
		 * Event handler: gets called when the sprite is removed from stage.
		 *  
		 * @param evt
		 * 
		 */		
		private function on_removed(evt:Event):void{
			kill();
			controller.kill();
			
			removeEventListener(Event.REMOVED_FROM_STAGE, on_removed);
			
			if(!is_inited){
				addEventListener(Event.ADDED_TO_STAGE, on_added);
			}
		}
	}
}