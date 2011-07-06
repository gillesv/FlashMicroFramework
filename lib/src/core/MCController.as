package core
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	
	/**
	 * 
	 * @author gillesv
	 * 
	 * This class allows you to easily control complex timeline based animations.
	 * 
	 * Note: this class was moved/renamed from be.proximity.framework.controllers.BaseMovieClipController, by the same author.
	 * 
	 */	
	public class MCController
	{
		protected var _mc:MovieClip;
		
		private var _targetFrame:FrameLabel;
		private var _callback:Function;
		private var _callbackparams:*;
		private var _isReversing:Boolean = false;
		private var _isLooping:Boolean = false;
		
		private var _isInited:Boolean = false;
		
		private var _frames:Array = [];
		
		/**
		 * Constructor. 
		 *  
		 * @param mc		the movieclip containing animation you want to control.
		 * @param autoInit	automatically initialize the enter frame listeners (default: true)
		 * 
		 */		
		public function MCController(mc:MovieClip, autoInit:Boolean = true)
		{
			this._mc = mc;
			
			if(autoInit)
				init();
		}
		
		/**
		 *  Begin the ENTER_FRAME listeners so the controller's methods can be used.
		 */		
		public function init():void{
			// collect all frames for comparisson
			_frames = _mc.currentScene.labels.concat();
			
			if(!_isInited)	
				_mc.addEventListener(Event.ENTER_FRAME, frame);
			
			_isInited = true;
		}
		
		/**
		 * Remove all ENTER_FRAME listeners so the controller can be cleanly removed. 
		 */		
		public function kill():void{
			_mc.removeEventListener(Event.ENTER_FRAME, frame);	
			
			_isInited = false;
		}
		
		// *** handler *** //
		
		/**
		 * @private
		 */		
		private function frame(evt:Event = null):void{
			if (_isReversing) {
				if (_targetFrame) {
					if (currentFrame == _targetFrame.frame) {
						_isReversing = false;		
						
						_targetFrame = null;
						
						if(callback != null)
							callback.apply(null, callbackParams);
						
					}else if (currentFrame == 1) {
						gotoAndStop(totalFrames);
						_isReversing = true;
					}else {
						prevFrame();
					}
				}else {
					if (currentFrame == 1) {
						gotoAndStop(totalFrames);
						_isReversing = true;
					}else {
						prevFrame();
					}
				}
			}else {
				if (_targetFrame) {
					if (currentFrame == _targetFrame.frame) {
						stop();
						
						_targetFrame = null;
						
						if(callback != null)
							callback.apply(null, callbackParams);
					}
				}
			}
		}
		
		private function setTargetFrame(frame:Object):void{
			_targetFrame = null;
			
			if (frame) {
				if (frame as Number && frame >= 1 && frame <= totalFrames){
					_targetFrame = new FrameLabel("", frame as Number);
				}else{
					for (var i:int = 0; i < _frames.length; i++) {
						var cfl:FrameLabel = _frames[i] as FrameLabel;
						
						if (cfl.name == String(frame)) {
							_targetFrame = cfl;
						}
					}			
				}					
			}					
		}
		
		// *** interface *** //
		/**
		 * Play until the frame is reached, then optionally call a function.
		 *  
		 * @param frame		a frame number or label.
		 * @param callback	OPTIONAL a method to call when the frame is reached.
		 * @param looping	OPTIONAL if true, the animation will continue playing past the target keyframe if called while at the target frame (default:false)
		 */	
		public function playUntil(frame:Object, callback:Function = null, params:* = null, looping:Boolean = false):void{
			_isLooping = looping;
			_isReversing = false;
			setTargetFrame(frame);
			
			if(_targetFrame && (currentFrame != _targetFrame.frame || (_isLooping && currentFrame == _targetFrame.frame)))
				play();
			
			this.callback = callback;
			this.callbackParams = params; 
		}
		
		/**
		 * Play the animation in reverse. 
		 */	
		public function reverse():void{
			setTargetFrame(null);
			
			if(_targetFrame && (currentFrame != _targetFrame.frame || (_isLooping && currentFrame == _targetFrame.frame)))
				_isReversing = true;
		}
		
		/**
		 * Reverse the animation until a frame is reached, then optionally call a function.
		 *  
		 * @param frame		a frame number or label.
		 * @param callback	OPTIONAL a method to call when the frame is reached.
		 * 
		 */	
		public function reverseUntil(frame:Object, callback:Function = null, params:* = null, looping:Boolean = false):void{
			_isLooping = looping;
			_isReversing = true;
			setTargetFrame(frame);
			
			this.callback = callback;
			this.callbackParams = params; 
		}
		
		/**
		 * Go to the frame, then reverse the animation.
		 *  
		 * @param frame		a frame number or label.
		 * 
		 */	
		public function gotoAndReverse(frame:Object):void{
			gotoAndStop(frame);
			reverse();
		}
		
		/**
		 * Go to the provided frame, via the shortest possible route. If you're at frame 15 and you pass goto(10), the movieclip will reverse 
		 * to the target frame. If you're at 15 and pass 20, it will move forwards.
		 *  
		 * @param frame the frame number of framelabel the animation should go to
		 * @param callback a method that should get called when the animation reaches its target
		 * @param params	any parameters that should be passed to the callback method upon completion
		 * @param looping	if true, the animation will move forward from the totalframes back to the start of the timeline (default: true)
		 * 
		 */		
		public function goto(frame:Object, callback:Function = null, params:* = null, looping:Boolean = false):void{
			stop();
			_isLooping = looping;
			setTargetFrame(frame);
			
			if(_targetFrame){
				if(currentFrame > _targetFrame.frame){
					reverseUntil(frame, callback, params, looping);
				}else if(currentFrame < _targetFrame.frame){
					playUntil(frame, callback, params, looping);
				}
			}
		}
		
		// **** overrides **** //
		/**
		 * Play the animation. 
		 */		
		public function play():void{
			_isReversing = false;
			_mc.play();	
		}
		
		/**
		 * Go to a frame in the animation and then play.
		 *  
		 * @param frame
		 * @param scene
		 * 
		 */		
		public function gotoAndPlay(frame:Object, scene:String = null):void{
			_isReversing = false;
			_mc.gotoAndPlay(frame, scene);	
		}
		
		/**
		 * Stop the animation. 
		 */		
		public function stop():void{
			_isReversing = false;
			_mc.stop();
		}
		
		/**
		 * Go to a frame in the animation, then stop.
		 *  
		 * @param frame
		 * @param scene
		 * 
		 */		
		public function gotoAndStop(frame:Object, scene:String = null):void{
			_isReversing = false;
			_mc.gotoAndStop(frame, scene);
		}
		
		/**
		 * Advance the animation with one frame. 
		 */		
		public function nextFrame():void{
			_mc.nextFrame();
		}
		
		/**
		 * Reverse the animation with one frame. 
		 */		
		public function prevFrame():void{
			_mc.prevFrame();	
		}
		
		// **** getters & setters **** //
		
		/**
		 * 
		 * @return the current Scene.
		 * 
		 */		
		public function get currentScene():Scene{
			return _mc.currentScene;
		}
		
		/**
		 * @return 	The total number of frames in the animation.
		 */		
		public function get totalFrames():int{
			return _mc.totalFrames;
		}	
		public function get currentFrame():int{
			return _mc.currentFrame;
		}
		
		/**
		 * Go to a specific frame in the animation.
		 *  
		 * @param value
		 * 
		 */		
		public function set currentFrame(value:int):void{
			_mc.gotoAndStop(value);
		}
		
		/**
		 * Is the animation currently reversing?
		 *  
		 * @return 	true or false.
		 * 
		 */		
		public function get isReversing():Boolean{
			return _isReversing;
		}
		public function set isReversing(value:Boolean):void{
			_isReversing = value;
		}
		
		/**
		 * A method that should be called when a frame is reached.
		 *  
		 * @return a function.
		 */		
		public function get callback():Function{
			return _callback;
		}		
		public function set callback(value:Function):void{
			_callback = value;
		}
		
		/**
		 * The parameters that are passed to the callback method, should it be called.
		 *  
		 * @return an object or an array of objects that should be passed to the callback method
		 * 
		 */		
		public function get callbackParams():*{
			return _callbackparams;
		}
		public function set callbackParams(value:*):void{
			_callbackparams = value;
		}
	}
}