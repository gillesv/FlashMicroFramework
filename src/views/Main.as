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
	import framework.events.PagingEvent;
	import framework.paging.Paging;
	import framework.paging.PagingLayers;
	import framework.paging.PagingTransitionTypes;
	import framework.paging.pages.ExternalPage;
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
		public var btnLoad:SimpleButton;
		public var btnLoadIPage:SimpleButton;
		
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
			
			paging.dispatchGlobalEvents = true;
			
			paging.transitionType = PagingTransitionTypes.TRANSITION_IN_OUT;
			
			// debug events
			/*
			paging.addEventListener(PagingEvent.PAGE_CHANGED, trace_event);
			paging.addEventListener(PagingEvent.PAGE_CHANGING, trace_event);
			paging.addEventListener(PagingEvent.PAGE_CLOSING, trace_event);
			paging.addEventListener(PagingEvent.PAGE_CLOSED, trace_event);
			
			addGlobalEventListener(PagingEvent.PAGE_CHANGED, trace_global_event);
			addGlobalEventListener(PagingEvent.PAGE_CHANGING, trace_global_event);
			addGlobalEventListener(PagingEvent.PAGE_CLOSING, trace_global_event);
			addGlobalEventListener(PagingEvent.PAGE_CLOSED, trace_global_event);
			*/
			
			router.addRoute("/load/:file", function(filename:String):void{
				paging.gotoPage(new ExternalPage(globalURL + "assets/swf/" + filename + ".swf", filename), "lol");
			});
			
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
		
		private function trace_global_event(evt:PagingEvent):void{
			trace("------");
			trace("Global:");
			trace(evt.type);
			trace(evt.page);
		}
		
		private function trace_event(evt:PagingEvent):void{
			trace("------");
			trace(evt.type);
			trace(evt.page);
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
			
			btnLoad.addEventListener(MouseEvent.CLICK, function():void{
				bridge.state = "load/StaticPage";
			});
			
			btnLoadIPage.addEventListener(MouseEvent.CLICK, function():void{
				bridge.state = "load/Page";
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