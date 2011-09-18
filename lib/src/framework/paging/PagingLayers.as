package framework.paging
{
	public class PagingLayers
	{
		public static const LAYER_POPUNDER:uint = 0;	// layer for adding changing content below the default (useful for animations/backgrounds/scenes/etc... upon which content can be layered)
		public static const LAYER_DEFAULT:uint = 1;	// default content layer
		public static const LAYER_UI:uint = 2;		// layer for adding global UI elements (header/footer/nav/etc...) on top of the content
		public static const LAYER_POPUPS:uint = 3;	// top-most layer for popups
	}
}