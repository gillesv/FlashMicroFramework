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
	
	import framework.router.Router;
	import framework.router.bridge.HistoryJSBridge;
	import framework.router.utils.PatternMatch;
	
	import locale.MultiLang;
	import locale.cms.MultiLangEditor;

	public dynamic class Main extends MC
	{
		public var btnHome:SimpleButton;
		public var btnAbout:SimpleButton;
		public var btnContact:SimpleButton;
		public var btnLang:SimpleButton;
		
		public var router:Router;
		public var bridge:HistoryJSBridge;
		
		
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var test:MultiLangTester = new MultiLangTester();
			test.setup();
			test.test();
			
			router = new Router();						
			router.addRoute("/:page", gotoAndStop);
			
			stop();
			
			btnHome.addEventListener(MouseEvent.CLICK, on_btn);
			btnAbout.addEventListener(MouseEvent.CLICK, on_btn);
			btnContact.addEventListener(MouseEvent.CLICK, on_btn);
			btnLang.addEventListener(MouseEvent.CLICK, on_btn);
			
			addChild(new MultiLangEditor());
			
			bridge = new HistoryJSBridge(router);
			bridge.addEventListener(Event.CHANGE, function():void{
				bridge.title = bridge.state.toString().substr(0, 1).toUpperCase() + bridge.state.toLowerCase().substr(1);
			});
			bridge.init();
		}
		
		private function on_btn(evt:MouseEvent):void{
			switch(evt.target){
				case btnHome:
					bridge.state = "HOME";
					break;
				case btnAbout:
					bridge.state = "ABOUT";
					break;
				case btnContact:
					bridge.state = "CONTACT";
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
import framework.router.Router;
import framework.router.utils.PatternMatch;

internal class RouterTester {
	
	public var router:Router;
	
	function RouterTester(){}
	
	public function setup():void{
		router = new Router();
	}
	
	public function test():void{
		router.addRoute("/", on_home);
		router.addRoute("/home", on_home); // string literal
		router.addRoute("/people/:id", on_people); // named parameters
		router.addRoute("/file/**", on_file); // wildcard parameters
		router.addRoute("/letter/*/to/*", on_letter); // unnamed parameters
		router.addRoute("/**", on_404);
		router.addRoute("/post/save", on_save);
		router.addRoute("/post/saved", on_saved);
		
		router.before(function(url:String):String{
			var match:PatternMatch = router.matches(url, ":lang/**");
			if(match.isMatch){
				if(match.params[0] == "NL"){
					log('set language to: ' + match.params[0]);
					
					router.redirect(match.params[1]);
					return null;
				}
			}
			
			return url;			
		});
		
		router.after(function(url:String):String{
			var match:PatternMatch = router.matches(url, "/post/save");
			
			if(match.isMatch){
				url = "/post/saved";
			}
						
			return url;
		});
		
		function on_home():void{
			trace("on home");
		}
		
		function on_people(id:String):void{
			trace("on people: " + id);
		}
		
		function on_file(file:String):void{
			trace("on file: " + file);
		}
		
		function on_letter(params:Array):void{
			trace("on letters: " + params.join(", "));
		}
		
		function on_404(url:String):void{
			trace("404 for url: " + url);
		}
		
		function on_save():void{
			trace("saving...");
		}
		
		function on_saved():void{
			trace("saved");
		}
		
		/*
		router.route("/");					// home
		
		router.route("/home");				// home
		router.route("/home/");				// home
		router.route("/people/gilles");		// people gilles
		router.route("/people/gilles/");	// people gilles
		router.route("/people");			// 404
		router.route("/file/a/path/to/a/file");	// file
		router.route("/letter/x/to/y");		// letter
		router.route("NL/people/gilles");	// switch language
		router.route("/post/save");
		*/
		
		router.route("NL/people/gilles");	// switch language & go to people
		//router.route("people/gilles");	// switch language & go to people
		trace(router.URL);
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