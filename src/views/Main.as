package views
{
	import core.*;

	public dynamic class Main extends MC
	{
		public function Main()
		{
			var test:MultiLangTester = new MultiLangTester();
			test.setup();
			test.test();
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
	}
	
	private function on_lang_loaded(evt:MultiLangEvent):void{
		trace("on_lang_loaded");
		
		trace(MultiLang.instance.getStringForPath("test/title/This is a title"));
		
		trace("toXML: ");
		trace(MultiLang.instance.toXML().toXMLString());
	}
	
	private function on_lang_changed(evt:MultiLangEvent):void{
		trace("on_lang_changed");
	}
	
	private function on_dynamic_value_changed(evt:MultiLangEvent):void{
		trace("on_dynamic_value_changed");	
	}
	
	
}