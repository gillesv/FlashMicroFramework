package views
{
	import core.*;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	import framework.config.Config;
	import framework.events.ConfigEvent;
	import framework.paging.Paging;
	import framework.router.Router;
	import framework.router.bridge.HistoryJSBridge;
	import framework.router.utils.PatternMatch;
	
	import locale.Language;
	import locale.MultiLang;
	import locale.cms.MultiLangEditor;
	import locale.events.MultiLangEvent;
	
	import views.pages.Home;

	public dynamic class Main extends MC
	{
		public var router:Router;
		public var paging:Paging;
		
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
			router.defaultRoute = "home";
			
			init_paging();
			
			var bridge:HistoryJSBridge = new HistoryJSBridge(router);
			bridge.init();
		}
		
		private function init_paging():void{
			paging = new Paging();
			var container:Sprite = new Sprite();
			container.name = "pagingContainer";
			addChild(container);
			paging.container = container;
			
			paging.factory = new Factory();
			
			paging.dispatchGlobalEvents = true;
			
			router.addRoute("/page/:id", function(id:String):void{
				// pass a string
				paging.gotoPage(id);
			});
			
			router.addRoute("/home", function():void{
				// pass an instanced DisplayObject conforming to IPage
				paging.gotoPage(new Home());
			});
			
			router.addRoute("/about", function():void{
				// Pass an instanced DisplayObject, not conforming to IPage
			});
			
			router.addRoute("/contact", function():void{
				// Pass a class
			});
			
			
		}
	}
}
import framework.paging.IPage;
import framework.paging.IPageFactory;

internal class Factory implements IPageFactory{
	
	public function createPage(id:String):IPage{
		switch(id){
			case "home":
				
				break;
		}
		
		return null;
	}
	
}