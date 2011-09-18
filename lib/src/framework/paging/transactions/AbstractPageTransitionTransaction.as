package framework.paging.transactions
{
	import flash.display.DisplayObject;
	
	import framework.paging.Paging;

	public class AbstractPageTransitionTransaction
	{
		
		public var nextPage:DisplayObject;
		public var prevPage:DisplayObject;
		public var paging:Paging;
		public var callback:Function;
		
		public function AbstractPageTransitionTransaction(nextPage:DisplayObject, prevPage:DisplayObject, paging:Paging){
			this.nextPage = nextPage;
			this.prevPage = prevPage;
			this.paging = paging;
		}
		
		public function transition(callback:Function):void{
			
		}
	}
}