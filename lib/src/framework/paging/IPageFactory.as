package framework.paging
{
	public interface IPageFactory
	{
		
		function createPage(id:String):IPage;
		
	}
}