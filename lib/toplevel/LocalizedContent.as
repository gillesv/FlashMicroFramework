package
{
	import core.MC;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import locale.MultiLang;
	import locale.components.LocaleLabel;
	import locale.components.LocaleLabelCollector;
	import locale.events.MultiLangEvent;
	
	public class LocalizedContent extends MC
	{
		private var collector:LocaleLabelCollector;
		private var id:String;
		
		public function LocalizedContent()
		{
			super();
			
			stop();
			
			this.visible = false;
		}
		
		override public function init():void{
			super.init();
			
			if(id == null || id == ""){
				var p:DisplayObjectContainer = this.parent;
				
				if(p != null){
					try{
						if(Object(p)["id"] != null && Object(p)["id"].toString() != ""){
							id = Object(p)["id"].toString();
						}else if(p.name.indexOf("instance") < 0 && p.name.toString() != "root1"){ // TODO: replace with regex for instanceNUMBER
							id = p.name;
						}
					}catch(err:Error){
						trace("couldn't get property id off of parent");
						trace(err);
					}
				}
			}
			
			if(id == null){
				id = this.name;
			}
			
				
			MultiLang.instance.addEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
			if(MultiLang.instance.isReady)
				on_lang_changed(new MultiLangEvent(MultiLangEvent.LANG_CHANGED));
			
			enterFrame(null);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		override public function kill():void{
			super.kill();
			
			if(collector)
				collector.kill();
			
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
			
			collectTextFields();
		}
	}
}