package
{
	import core.MC;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import locale.MultiLang;
	import locale.components.LocaleLabel;
	import locale.events.MultiLangEvent;
	
	public class LocalizedContent extends MC
	{
		private var textfields:Array = [];
		
		public var id:String = "";
		
		public function LocalizedContent()
		{
			super();
			
			stop();
			
			mouseChildren = false;
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
				if(MultiLang.instance.lang == "NL")
					MultiLang.instance.lang = "FR";
				else
					MultiLang.instance.lang = "NL";
			});
		}
		
		override public function init():void{
			super.init();
			
			if(id == "")
				id = this.name;
			
			MultiLang.instance.addEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		override public function kill():void{
			super.kill();
			
			MultiLang.instance.removeEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
			
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function on_lang_changed(evt:MultiLangEvent):void{
			gotoAndStop(evt.lang);
		}
		
		private function collectTextFields():void{
			var i:int = 0;
			var label:LocaleLabel;
			
			for(i = 0; i < textfields.length; i++){
				label = textfields[i] as LocaleLabel;
				label.kill();
			}
			
			textfields = [];
			
			for(i = 0; i < numChildren; i++){
				if(getChildAt(i) as TextField){
					var txt:TextField = getChildAt(i) as TextField;
					var path:String = txt.name;
					if(section != "")
						path = section + "/" + path;
					
					label = new LocaleLabel(txt, path);
					textfields.push(label);
				}
			}
			
		}
		
		private var _lastFrame:int;
		
		private function enterFrame(evt:Event):void{
			if(currentFrame != _lastFrame){
				collectTextFields();
				
				_lastFrame = currentFrame;
			}
		}
		
		public function get section():String{
			return this.id;
		}
		public function set section(value:String):void{
			this.id = value;
		}
	}
}