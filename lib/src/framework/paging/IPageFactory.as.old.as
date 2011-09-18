package framework.paging
{
	import framework.paging.page.IPage;

	public interface IPageFactory
	{
		
		function createPage(id:String):IPage;
		
	}
}