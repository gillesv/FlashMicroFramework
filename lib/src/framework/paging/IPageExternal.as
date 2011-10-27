package framework.paging
{
	public interface IPageExternal extends IPage
	{
		function get defaultController():ITransitionController;
		function set defaultController(value:ITransitionController):void;
	}
}