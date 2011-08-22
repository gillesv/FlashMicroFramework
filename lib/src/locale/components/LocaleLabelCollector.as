package locale.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class LocaleLabelCollector
	{
		public var container:DisplayObjectContainer;
		public var section:String;
		public var ignore:Array;
		
		public var labels:Array = [];
		
		public function LocaleLabelCollector(container:DisplayObjectContainer, section:String = "", ignore:Array = null){
			this.container = container;
			this.section = section;
			
			if(!ignore)
				ignore = [];
			
			this.ignore = ignore;
		}
		
		public function collectLabels():void{
			this.labels = [];
			
			var txt:TextField, child:DisplayObject, path:String = "";
			
			for(var i:int = 0; i < container.numChildren; i++){
				child = container.getChildAt(i);
				
				if(section != "")
					path = section + "/";
				else
					path = "";
				
				if(child as TextField && ignore.indexOf(child) < 0 && ignore.indexOf(child.name) < 0){
					txt = child as TextField;
					
					if(txt.type != TextFieldType.INPUT){
						labels.push(new LocaleLabel(txt, path + txt.name));
					}
				}
			}
		}
		
		public function kill():void{
			while(labels.length > 0)
				LocaleLabel(labels.shift()).kill();
		}
	}
}