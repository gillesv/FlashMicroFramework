package locale.cms
{
	import core.S;
	
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import locale.MultiLang;
	import locale.events.MultiLangEvent;
	
	public class MultiLangEditor extends S
	{
		private var menu:TextField;
		private var langs:Array;
		private var langIndex:int = 0;
		
		public function MultiLangEditor()
		{
			super();
		}
		
		override public function init():void{
			menu = new TextField();
			menu.selectable = false;
			menu.autoSize = TextFieldAutoSize.LEFT;
			menu.multiline = false;
			menu.y = 5;
			addChild(menu);
			
			renderMenu();
			
			menu.addEventListener(TextEvent.LINK, on_action);
			MultiLang.instance.addEventListener(MultiLangEvent.BEGIN_EDIT, on_begin_edit);
			MultiLang.instance.addEventListener(MultiLangEvent.END_EDIT, on_end_edit);
			MultiLang.instance.addEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
			stage.addEventListener(Event.RESIZE, on_resized);
		}
		
		private function renderMenu():void{
			var style:TextFormat = new TextFormat("Helvetica", 12, 0xffffff, true);
			style.leftMargin = 20;
			style.rightMargin = 20;
			menu.defaultTextFormat = style;
			menu.setTextFormat(style);
			
			menu.htmlText = menuCopy;
			
			this.graphics.clear();
			this.graphics.beginFill(0xcc0000, 1);
			this.graphics.drawRect(0, 0, menu.width, 25);
			this.graphics.endFill();
			
			on_resized(null);
		}
		
		private function on_resized(evt:Event):void{
			this.y = stage.stageHeight - 25;
		}
		
		private function get menuCopy():String{
			if(MultiLang.instance.isEditing)
				return "<a href='event:edit'>Stop editing</a> | <a href='event:export'>Export XML</a>";
			
			if(langs){
				langIndex = langs.indexOf(MultiLang.instance.lang);
				var nextlang:int = (langIndex < langs.length - 1)? langIndex + 1 : 0;
				
				return "<a href='event:edit'>Edit copy</a> | <a href='event:switch'>Change language to " + langs[nextlang].toString()  + " </a> | <a href='event:export'>Export XML</a>";
			}
			
			return "<a href='event:edit'>Edit copy</a> | <a href='event:switch'>Change language</a> | <a href='event:export'>Export XML</a>";
		}
		
		private function on_lang_changed(evt:MultiLangEvent):void{
			MultiLang.instance.isEditing = false;
			
			if(!langs){
				langs = MultiLang.instance.languageIds;
			}
			
			renderMenu();
		}
		
		private function on_begin_edit(evt:MultiLangEvent):void{
			renderMenu();
		}
		
		private function on_end_edit(evt:MultiLangEvent):void{
			renderMenu();
		}
		
		private function on_action(evt:TextEvent):void{
			switch(evt.text){
				case "edit":
					// toggle edit mode
					MultiLang.instance.isEditing = !MultiLang.instance.isEditing;					
					break;
				case "switch":					
					if(!langs){
						langs = MultiLang.instance.languageIds;
					}
					
					langIndex ++;
					
					if(langIndex > langs.length - 1)
						langIndex = 0;
					
					MultiLang.instance.lang = langs[langIndex];					
					break;
				case "export":
					MultiLang.instance.saveXML();
					break;
			}
		}
	}
}