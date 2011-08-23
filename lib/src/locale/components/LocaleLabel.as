package locale.components
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import locale.MultiLang;
	import locale.events.MultiLangEvent;

	public class LocaleLabel
	{
		public var txt:TextField;
		public var path:String;
		public var comment:String;
		
		private var _last_lang:String = "";
		
		
		/**
		 * Transform any dynamic textfield into a localized label, complete with responsive behaviors and CMS-integration
		 * 
		 * @param txt		the textfield
		 * @param path		the path to the localized content: e.g home/title or about/content or error/email, etc...
		 * @param comment	optional comment to aid copywriters/translators
		 * 
		 */		
		public function LocaleLabel(txt:TextField, path:String, comment:String = ""){
			this.txt = txt;
			this.path = path;
			this.comment = comment;
			
			this.txt.addEventListener(Event.REMOVED_FROM_STAGE, on_kill);
			MultiLang.instance.addEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
			MultiLang.instance.addEventListener(MultiLangEvent.DYNAMIC_VALUE_CHANGED, on_dynamic_value_changed);
			MultiLang.instance.addEventListener(MultiLangEvent.BEGIN_EDIT, on_begin_edit);
			MultiLang.instance.addEventListener(MultiLangEvent.END_EDIT, on_end_edit);
			
			if(MultiLang.instance.isReady)
				on_lang_changed(new MultiLangEvent(MultiLangEvent.LANG_CHANGED));
			
			if(MultiLang.instance.isEditing)
				on_begin_edit(null);
		}
		
		public function kill():void{
			this.txt.removeEventListener(Event.REMOVED_FROM_STAGE, on_kill);
			MultiLang.instance.removeEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
			MultiLang.instance.removeEventListener(MultiLangEvent.DYNAMIC_VALUE_CHANGED, on_dynamic_value_changed);
			MultiLang.instance.removeEventListener(MultiLangEvent.BEGIN_EDIT, on_begin_edit);
			MultiLang.instance.removeEventListener(MultiLangEvent.END_EDIT, on_end_edit);
		}
		
		/**
		 * Language changed - change copy
		 */		
		private function on_lang_changed(evt:MultiLangEvent):void{
			if(_last_lang != evt.lang){
				_last_lang = evt.lang;
				
				if(!MultiLang.instance.pathExists(path)){
					MultiLang.instance.setStringForPath(txt.text, path, (comment == "")? txt.text : comment);
				}
				
				txt.htmlText = MultiLang.instance.getStringForPath(path);
			}
		}
		
		/**
		 * Dynamic value changed, update label if it contains said value
		 */		
		private function on_dynamic_value_changed(evt:MultiLangEvent):void{
			if(MultiLang.instance.isReady){
				var value:String = MultiLang.instance.getStringForPath(path);
				
				if(txt.htmlText != value)
					txt.htmlText = value;
			}
		}
		
		/**
		 * Edit begins - set selectable to true, update the copy, etc
		 */		
		private function on_begin_edit(evt:MultiLangEvent):void{
			txt.selectable = true;
			txt.type = TextFieldType.INPUT;
			txt.text = MultiLang.instance.getStringForPath(path);
			
			txt.addEventListener(FocusEvent.FOCUS_IN, on_focus_in);
			txt.addEventListener(FocusEvent.FOCUS_OUT, on_focus_out);
		}
		
		private function on_focus_in(evt:FocusEvent):void{
			txt.addEventListener(Event.CHANGE, on_change);
		}
		
		private function on_focus_out(evt:FocusEvent):void{
			txt.removeEventListener(Event.CHANGE, on_change);
		}
		
		private function on_change(evt:Event):void{
			MultiLang.instance.setStringForPath(txt.text, path);
		}
		
		/**
		 * Edit ends 
		 */	
		private function on_end_edit(evt:MultiLangEvent):void{
			txt.selectable = false;
			txt.type = TextFieldType.DYNAMIC;
			
			txt.removeEventListener(FocusEvent.FOCUS_IN, on_focus_in);
			txt.removeEventListener(FocusEvent.FOCUS_OUT, on_focus_out);
			txt.removeEventListener(Event.CHANGE, on_change);
			
			txt.htmlText = MultiLang.instance.getStringForPath(path);
		}
		
		/**
		 * Removed from stage 
		 */		
		private function on_kill(evt:Event):void{
			kill();
		}
	}
}