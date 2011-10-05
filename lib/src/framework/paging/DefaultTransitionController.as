package framework.paging
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class DefaultTransitionController implements ITransitionController
	{
		public function DefaultTransitionController(){}
		
		public function setupIntro(page:DisplayObject):void{
			page.alpha = 0;
			page.visible = false;
		}
		
		public function setupOutro(page:DisplayObject):void{
			
		}
		
		/**
		 * Fades the page in from 0
		 *  
		 * @param page
		 * @param callback
		 * @param callbackParams
		 * 
		 */		
		public function animatePageIn(page:DisplayObject, callback:Function, callbackParams:*):void{
			page.visible = true;
			
			var startingblend:String = page.blendMode; // store the original blendmode
			
			if(page.blendMode == BlendMode.NORMAL){	// if there isn't a special blendmode, set it to layer for neater transition
				page.blendMode = BlendMode.LAYER;
			}
			
			page.addEventListener(Event.ENTER_FRAME, fadein);
			
			function fadein(evt:Event):void{
				page.alpha += (1 - page.alpha)/10;
				
				if(page.alpha > 0.9){
					page.alpha = 1;
					page.blendMode = startingblend;	 // revent back to previous blendmode, if changed
					page.removeEventListener(Event.ENTER_FRAME, fadein);
					
					callback.apply(null, callbackParams);	// callback
				}
			};
		}
		
		/**
		 * Fades the page out to 0 alpha
		 *  
		 * @param page
		 * @param callback
		 * @param callbackParams
		 * 
		 */		
		public function animatePageOut(page:DisplayObject, callback:Function, callbackParams:*):void{
			if(page.blendMode == BlendMode.NORMAL){	// if there isn't a special blendmode, set it to layer for neater transition
				page.blendMode = BlendMode.LAYER;
			}
			
			page.addEventListener(Event.ENTER_FRAME, fadeout);
			
			function fadeout(evt:Event):void{
				page.alpha += (0 - page.alpha)/10;
				
				if(page.alpha < 0.1){
					page.alpha = 0;
					
					page.removeEventListener(Event.ENTER_FRAME, fadeout);
					
					callback.apply(null, callbackParams);
				}
			}
		}
	}
}