package framework.loading.views
{
	import core.MC;
	
	public class AbstractLoadingView extends MC
	{
		public function AbstractLoadingView(init_on_stage:Boolean = true)
		{
			super(init_on_stage);
		}
		
		protected function show():void{
			throw new Error('Please override the "show" method');
		}
		
		protected function hide():void{
			throw new Error('Please override the "hide" method');
		}
		
		override final public function set visible(value:Boolean):void{
			if(value){
				show();
			}else{
				hide();
			}
		}
		override final public function get visible():Boolean{
			return super.visible;
		}
	}
}