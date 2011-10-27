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
		
		/**
		 * Utility class designed to make localizing a whole bunch of dynamic textfields a cinch. 
		 * 
		 * Usage: 
		 * design your content in the flash IDE
		 * make all textfields dynamic and give them unique instance names (and embed the fonts, if necesary)
		 * in your document-class (or whatever class is tied to the container of these textfields), create an instance of a LocaleLabelCollector like so:
		 * 
		 * new LocaleLabelCollector(this, "THE_SECTION").collectLabels();
		 *  
		 * @param container		the displayobjectcontainer which contains (groan) the dynamic textfields to be localized
		 * @param section		the section-id under which all key-content will be searched/stored
		 * @param ignore		an array of instances or instance-names of textfields not to be collected for localization (note: input textfields are automatically ignored)
		 * 
		 */		
		public function LocaleLabelCollector(container:DisplayObjectContainer, section:String = "", ignore:Array = null){
			this.container = container;
			this.section = section;
			
			if(!ignore)
				ignore = [];
			
			this.ignore = ignore;
		}
		
		/**
		 * Collect all labels 
		 */		
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
		
		/**
		 * Cleanup & garbage-collection 
		 */		
		public function kill():void{
			while(labels.length > 0)
				LocaleLabel(labels.shift()).kill();
		}
	}
}