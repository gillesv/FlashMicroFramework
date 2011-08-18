package locale
{
	public class Key
	{
		public var id:String = "";
		public var section:String = "";
		public var content:String = "";
		public var comment:String = "";
		public var tag:String = "";
		
		public function Key(){
			
		}
		
		public function fromXML(xml:XML):void{
			this.id = xml.@id;
			this.tag = xml.@tag;
			this.content = xml.content.toString();
			this.comment = xml.comment.toString();
		}
		
		public function toXML():XML{
			return new XML();
		}
	}
}