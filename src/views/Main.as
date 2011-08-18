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
		addGlobalEventListener(MultiLangEvent.LANG_LOADED, on_lang_loaded);
		addGlobalEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
		addGlobalEventListener(MultiLangEvent.DYNAMIC_VALUE_CHANGED, on_dynamic_value_changed);
	}
	
	public function tearDown():void{
		removeGlobalEventListener(MultiLangEvent.LANG_LOADED, on_lang_loaded);
		removeGlobalEventListener(MultiLangEvent.LANG_CHANGED, on_lang_changed);
		removeGlobalEventListener(MultiLangEvent.DYNAMIC_VALUE_CHANGED, on_dynamic_value_changed);
	}
	
	public function test():void{
		MultiLang.instance.addLanguage(new Language("NL", globalURL + "data/flashCopy_NL.xml"));
		MultiLang.instance.addLanguage(new Language("FR", globalURL + "data/flashCopy_FR.xml"));
	}
	
	private function on_lang_loaded(evt:MultiLangEvent):void{
		trace("on_lang_loaded");
	}
	
	private function on_lang_changed(evt:MultiLangEvent):void{
		trace("on_lang_changed");
	}
	
	private function on_dynamic_value_changed(evt:MultiLangEvent):void{
		trace("on_dynamic_value_changed");	
	}
	
	
}