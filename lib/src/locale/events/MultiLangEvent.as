package locale.events
{
	import flash.events.Event;
	
	import framework.events.GlobalEvent;
	
	import locale.MultiLang;
	
	public class MultiLangEvent extends GlobalEvent
	{
		
		public static const LANG_CHANGED:String = "langChanged";
		public static const LANG_LOADED:String = "langLoaded";
		
		public static const DYNAMIC_VALUE_CHANGED:String = "dynamicValueChanged";
		
		public static const BEGIN_EDIT:String = "beginEditing";
		public static const END_EDIT:String = "endEditing";
		
		public var lang:String;
		
		public function MultiLangEvent(type:String, lang:String)
		{
			super(type);
			
			if(!lang)
				this.lang = MultiLang.instance.lang;
			else
				this.lang = lang;
		}
		
		override public function clone():Event{
			return new MultiLangEvent(type, lang);
		}
	}
}