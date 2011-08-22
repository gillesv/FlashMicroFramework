package
{
	import core.MC;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import locale.MultiLang;
	import locale.components.LocaleLabel;
	import locale.components.LocaleLabelCollector;
	import locale.events.MultiLangEvent;
	
	public class LocalizedContent extends MC
	{
		//private var textfields:Array = [];
		private var collector:LocaleLabelCollector;
		
		[Editable]
		public var id:String = "";
		
		public function LocalizedContent()
		{
			super();
			
			stop();
			
			this.visible = false;
			
			/*
			mouseChildren = false;
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
				if(MultiLang.instance.lang == "NL")
					MultiLang.instance.lang = "FR";
				else
					MultiLang.instance.lang = "NL";
			});
			*/
		}
		
		override public function init():void{
			super.init();
			
			if(id == "")
				id = this.name;
			
			MultiLang.instance.addEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
			if(MultiLang.instance.isReady)
				on_lang_changed(new MultiLangEvent(MultiLangEvent.LANG_CHANGED));
			
			enterFrame(null);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		override public function kill():void{
			super.kill();
			
			MultiLang.instance.removeEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
			
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			removeEventListener(Event.ENTER_FRAME, show);
		}
		
		private function on_lang_changed(evt:MultiLangEvent):void{
			this.visible = false;
			gotoAndStop(evt.lang);
			addEventListener(Event.ENTER_FRAME, show);
		}
		
		private function collectTextFields():void{
			if(collector)
				collector.kill();
			
			collector = new LocaleLabelCollector(this, section);
			collector.collectLabels();
			/*
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
			*/
			
		}
		
		private var _lastFrame:int;
		
		private function enterFrame(evt:Event):void{
			if(currentFrame != _lastFrame){
				collectTextFields();
				
				_lastFrame = currentFrame;
			}
		}
		
		private function show(evt:Event = null):void{
			this.visible = true;
			this.removeEventListener(Event.ENTER_FRAME, show);
		}
		
		public function get section():String{
			return this.id;
		}
		public function set section(value:String):void{
			this.id = value;
		}
	}
}