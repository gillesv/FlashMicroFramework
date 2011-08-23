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
		
		/**
		 * Used as a baseclass, this adds a wealth of functionality to any movieclip confirming to the following assumptions:
		 * 
		 * It contains dynamic textfields that have been given unique instance-names
		 * It is either single-frame, or contains labeled frames for every language the site supports (i.e a frame labeled "EN" or "FR")
		 * 
		 * When initialized, the LocalizedContent sets itself to the correct frame according to the current locale, and cleanly collects all dynamic textfields,
		 * turning them into dynamic LocaleLabels. 
		 * 
		 * The content from these labels is got according to the following logic:
		 * If the LocalizedContent's section property is set (before being added to stage) that value is the section key.
		 * If the LocalizedContent is placed inside another displayobject that has a property "id", that 'id' is used as the section key
		 * If the LocalizedContent's parent does not posses an 'id', it takes the name of the parent, so long as it is not the document-root or created at runtime (so that it's not some 
		 * random gibberish like Instance625 or something)
		 * If the parent's id is invalid, it uses the LocalizedContent's instancename (provided of course, it also isn't randomly generated)
		 * If all else fails, it uses an empty section and searches for content in the root of the translation-file
		 * 
		 * The goal is to make localization & copy-writing as painless and automated as possible.
		 */		
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
			
			if(id == null && this.name.indexOf("instance") < 0){
				id = this.name;
			}else{
				id = "";
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