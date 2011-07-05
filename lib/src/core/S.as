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
		
		/* event handlers */
		
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