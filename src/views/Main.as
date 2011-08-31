package views
{
	import core.*;
	
	import flash.display.SimpleButton;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	import framework.config.Config;
	import framework.events.ConfigEvent;
	import framework.router.Router;
	import framework.router.bridge.HistoryJSBridge;
	import framework.router.utils.PatternMatch;
	
	import locale.Language;
	import locale.MultiLang;
	import locale.cms.MultiLangEditor;
	import locale.events.MultiLangEvent;

	public dynamic class Main extends MC
	{
		public var router:Router;
		
		public function Main()
		{			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stop();
		}
		
		override public function init():void{
			addGlobalEventListener(ConfigEvent.CONFIG_LOADED, on_config_loaded);
			Config.instance.init(stage);
		}
		
		private function on_config_loaded(evt:ConfigEvent):void{
			removeGlobalEventListener(ConfigEvent.CONFIG_LOADED, on_config_loaded);
			
			addGlobalEventListener(MultiLangEvent.LANG_LOADED, locale_ready);
			
			for(var i:int = 0; i < Config.instance.languageIds.length; i++){
				MultiLang.instance.addLanguage(new Language(Config.instance.languageIds[i], Config.instance.getLanguageURLForId(Config.instance.languageIds[i])));
			}			
		}
		
		private function locale_ready(evt:MultiLangEvent):void{
			removeGlobalEventListener(MultiLangEvent.LANG_LOADED, locale_ready);
			
			router = new Router();
			var bridge:HistoryJSBridge = new HistoryJSBridge(router);
			bridge.init();
		}
	}
}