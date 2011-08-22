package locale.components
{
	import flash.events.Event;
	import flash.text.TextField;
	
	import locale.MultiLang;
	import locale.events.MultiLangEvent;

	public class LocaleLabel
	{
		public var txt:TextField;
		public var path:String;
		public var comment:String;
		
		private var _last_lang:String = "";
		
		public function LocaleLabel(txt:TextField, path:String, comment:String = ""){
			this.txt = txt;
			this.path = path;
			this.comment = comment;
			
			this.txt.addEventListener(Event.REMOVED_FROM_STAGE, on_kill);
			MultiLang.instance.addEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
			
			if(MultiLang.instance.isReady)
				on_lang_changed(new MultiLangEvent(MultiLangEvent.LANG_CHANGED));
		}
		
		public function on_lang_changed(evt:MultiLangEvent):void{
			if(_last_lang != evt.lang){
				_last_lang = evt.lang;
				
				if(!MultiLang.instance.pathExists(path)){
					MultiLang.instance.setStringForPath(txt.htmlText, path, (comment == "")? txt.text : comment);
				}
				
				txt.htmlText = MultiLang.instance.getStringForPath(path);
			}
		}
		
		public function kill():void{
			this.txt.removeEventListener(Event.REMOVED_FROM_STAGE, on_kill);
			MultiLang.instance.removeEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
		}
		
		private function on_kill(evt:Event):void{
			kill();
		}
	}
}