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
	import framework.paging.PagingTransitionTypes;
	import framework.router.Router;
	import framework.router.bridge.HistoryJSBridge;
	import framework.router.utils.PatternMatch;
	
	import locale.Language;
	import locale.MultiLang;
	import locale.cms.MultiLangEditor;
	import locale.events.MultiLangEvent;
	
	import views.pages.About;
	import views.pages.Contact;
	import views.pages.Home;

	public dynamic class Main extends MC
	{
		public var router:Router;
		public var bridge:HistoryJSBridge;
		
		public var btnHome:SimpleButton;
		public var btnAbout:SimpleButton;
		public var btnContact:SimpleButton;
		
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
			
			bridge = new HistoryJSBridge(router);
			bridge.init();
			
			init_nav();
		}
		
		private function init_paging():void{
			var container:Sprite = new Sprite();
			container.name = "pagingContainer";
			addChild(container);
			
			var paging:Paging = new Paging(container);
			paging.factory = new PageFactory();
			
			//paging.transitionType = PagingTransitionTypes.TRANSITION_IN_OUT;
			
			router.addRoute("/page/:id", function(id:String):void{
				// pass a string
				paging.gotoPage(id, null);
			});
			
			router.addRoute("/home", function():void{
				// pass an instanced DisplayObject conforming to IPage
				paging.gotoPage(new Home(), null);
			});
			
			router.addRoute("/about", function():void{
				// Pass an instanced DisplayObject, not conforming to IPage
				paging.gotoPage(new About(), null);
			});
			
			router.addRoute("/contact", function():void{
				// Pass a class
				paging.gotoPage(Contact, null);
			});
			
			
		}
		
		private function init_nav():void{
			btnHome.addEventListener(MouseEvent.CLICK, function():void{
				bridge.state = "home";
			});
			
			btnAbout.addEventListener(MouseEvent.CLICK, function():void{
				bridge.state = "about";
			});
			
			btnContact.addEventListener(MouseEvent.CLICK, function():void{
				bridge.state = "contact";
			});
		}
	}
}
import framework.paging.IPage;
import framework.paging.IPageFactory;

import views.pages.Home;

internal class PageFactory implements IPageFactory{
	
	public function createPage(id:String):IPage{
		switch(id){
			case "home":
				
				return new Home();
				
				break;
		}
		
		
		return null;
	}
	
}