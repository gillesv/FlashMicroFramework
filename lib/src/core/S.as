package core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 
	 * @author gillesv
	 * 
	 * Replacement for BaseSprite: again, a lot easier to type core.S into the BaseClass field than be.proximity.framework.core.BaseSprite...
	 *  
	 */	
	public class S extends Sprite
	{
		/**
		 * Boolean: has the init() method been called automatically before? 
		 */		
		protected var is_inited:Boolean = false;
		
		/**
		 * Easily overridable dimensions.
		 * 
		 * If you want a precise or self-calculated width or height for your sprite, simply set these values and to all
		 * concerned, your sprite will measure exactly these values. 
		 */		
		protected var _width:Number = -1;
		protected var _height:Number = -1;
		
		public function S()
		{
			super();
			
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
			
			removeEventListener(Event.REMOVED_FROM_STAGE, on_removed);
			
			if(!is_inited){
				addEventListener(Event.ADDED_TO_STAGE, on_added);
			}
		}
	}
}