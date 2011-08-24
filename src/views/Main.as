package views
{
	import core.*;
	
	import flash.display.SimpleButton;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import locale.MultiLang;
	import locale.cms.MultiLangEditor;

	public dynamic class Main extends MC
	{
		public var btnHome:SimpleButton;
		public var btnAbout:SimpleButton;
		public var btnContact:SimpleButton;
		public var btnLang:SimpleButton;
		
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var test:MultiLangTester = new MultiLangTester();
			test.setup();
			test.test();
			
			stop();
			
			btnHome.addEventListener(MouseEvent.CLICK, on_btn);
			btnAbout.addEventListener(MouseEvent.CLICK, on_btn);
			btnContact.addEventListener(MouseEvent.CLICK, on_btn);
			btnLang.addEventListener(MouseEvent.CLICK, on_btn);
			
			addChild(new MultiLangEditor());
			
			// History.js experimentation
			if(ExternalInterface.available){
				ExternalInterface.addCallback("changeState", on_state_change);
				ExternalInterface.call("initFlashHistoryBridge");
			}
			
			log("init cache 3");
		}
		
		private function on_state_change(state:String):void{
			gotoAndStop(state);
			//log(state);
		}
		
		private function set_state(state:String):void{
			if(ExternalInterface.available){
				ExternalInterface.call("flashPushHistoryState", state);
			}else{
				on_state_change(state);
			}
		}
		
		private function on_btn(evt:MouseEvent):void{
			switch(evt.target){
				case btnHome:
					set_state("HOME");
					break;
				case btnAbout:
					set_state("ABOUT");
					break;
				case btnContact:
					set_state("CONTACT");
					break;
				case btnLang:
					
					if(MultiLang.instance.lang == "NL")
						MultiLang.instance.lang = "FR";
					else
						MultiLang.instance.lang = "NL";
					
					break;
			}
		}
	}
}
import locale.Language;
import locale.MultiLang;
import locale.events.MultiLangEvent;

internal class MultiLangTester {
	
	function MultiLangTester(){
		
	}
	
	public function setup():void{
		MultiLang.instance.addEventListener(MultiLangEvent.LANG_LOADED, on_lang_loaded);
		MultiLang.instance.addEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
		MultiLang.instance.addEventListener(MultiLangEvent.DYNAMIC_VALUE_CHANGED, on_dynamic_value_changed);
	}
	
	public function tearDown():void{
		MultiLang.instance.removeEventListener(MultiLangEvent.LANG_LOADED, on_lang_loaded);
		MultiLang.instance.removeEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
		MultiLang.instance.removeEventListener(MultiLangEvent.DYNAMIC_VALUE_CHANGED, on_dynamic_value_changed);
	}
	
	public function test():void{
		MultiLang.instance.addLanguage(new Language("NL", globalURL + "data/flashCopy_NL.xml"));
		MultiLang.instance.addLanguage(new Language("FR", globalURL + "data/flashCopy_FR.xml"));
		MultiLang.instance.setDynamicValue("dynamicvalue", "lol");
	}
	
	private function on_lang_loaded(evt:MultiLangEvent):void{
		//trace(MultiLang.instance.getStringForPath("test/title/This is a title"));
		
		//trace("toXML: ");
		//trace(MultiLang.instance.toXML().toXMLString());
		//MultiLang.instance.saveXML();
	}
	
	private function on_lang_changed(evt:MultiLangEvent):void{
		//trace("on_lang_changed");
	}
	
	private function on_dynamic_value_changed(evt:MultiLangEvent):void{
		//trace("on_dynamic_value_changed");	
	}
	
	
}