package framework.paging
{
	/**
	 * 
	 * @author gillesv
	 * 
	 * Interface that could theoretically allow pages to be reused rather than re-instantiated. 
	 * 
	 */	
	public interface IPausable extends IPage
	{
		function pause():void;
		function resume():void;
	}
}