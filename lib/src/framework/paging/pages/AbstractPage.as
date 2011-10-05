package framework.paging.pages
{
	import core.MC;
	
	import framework.paging.IPage;
	
	/**
	 * @author gillesv
	 * 
	 * Abstract skeleton page to take the load off of most cases.
	 *  
	 */	
	public class AbstractPage extends MC implements IPage
	{
		protected var _id:String;
		protected var _canAnimateIn:Boolean;
		protected var _canAnimateOut:Boolean;
		
		/**
		 * The AbstractPage class provides a skeleton class that can prevent some code duplication in common or generic cases.
		 *  
		 * @param id			unique string id to be associated with this page.
		 * @param canAnimateIn	does this page implement its own custom intro animation? (@default: false)
		 * @param canAnimateOut does this page implement its own custom outro animation? (@default: false)
		 * 
		 */		
		public function AbstractPage(id:String, canAnimateIn:Boolean = false, canAnimateOut:Boolean = false)
		{
			super();
			
			this._id = id;
			this._canAnimateIn = canAnimateIn;
			this._canAnimateOut = canAnimateOut;
		}
		
		public final function get id():String
		{
			return this._id;
		}
		
		public function setup(params:*=null):void{
			if(params != null){
				throw new Error("Error, AbstractPage '" + id + "' has received unhandled params: " + params + ". Please override the setup() method to prevent this error.");
			}
		}
		
		/**
		 * Allows you to setup several internal properties in preparation of the upcoming transition handled in animateIn() 
		 */		
		public function setupIntro():void{
			throw new Error("Error, AbstractPage '" + id + "' is set to canAnimateIn = true, but the required setupIntro method hasn't been overridden. Please override the page's setupIntro() method to prevent this error.");
		}
		
		/**
		 * Allows you to setup several internal properties in preparation of the upcoming transition handled in animateOut() 
		 */	
		public function setupOutro():void{
			throw new Error("Error, AbstractPage '" + id + "' is set to canAnimateOut = true, but the required setupOutro method hasn't been overridden. Please override the page's setupOutro() method to prevent this error.");
		}
		
		public function animateIn(callback:Function, callbackParams:*):void
		{
			throw new Error("Error, AbstractPage '" + id + "' is set to canAnimateIn = true, but the required animateIn method hasn't been overridden. Please override the page's animateIn() method to prevent this error.");
		}
		
		public function animateOut(callback:Function, callbackParams:*):void
		{
			throw new Error("Error, AbstractPage '" + id + "' is set to canAnimateOut = true, but the required animateOut method hasn't been overridden. Please override the page's animateOut() method to prevent this error.");
		}
		
		public final function get canAnimateIn():Boolean
		{
			return _canAnimateIn;
		}
		
		public final function get canAnimateOut():Boolean
		{
			return _canAnimateOut;
		}
	}
}