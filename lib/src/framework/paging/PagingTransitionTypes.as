package framework.paging
{
	public class PagingTransitionTypes
	{
		public static const TRANSITION_IN_OUT:String = "in_out";		// old page is animated out, then the new page is animated in
		public static const TRANSITION_IN:String = "in";				// old page is instantly removed/killed, new page animates in
		public static const TRANSITION_CROSSFADE:String = "crossFade";	// old page and new page simultaneously transition out and in, respectively
		public static const TRANSITION_NONE:String = "none";			// no transitions, just add & remove
		
		public static const TRANSITIONS:Array = [TRANSITION_IN_OUT, TRANSITION_IN, TRANSITION_CROSSFADE, TRANSITION_NONE];
	}
}