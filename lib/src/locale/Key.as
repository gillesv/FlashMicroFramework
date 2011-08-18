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
			var xml:XML = <key/>;
			
			xml.@id = this.id;
			
			if(tag != ""){
				xml.@tag = tag;
			}
			
			var xmlContent:XML = <content/>;
			xmlContent.appendChild(content);
			xml.appendChild(xmlContent);
			
			if(comment != ""){
				var xmlComment:XML = <comment />;
				xmlComment.appendChild(comment);
				xml.appendChild(xmlComment);
			}
			
			return xml;
		}
		
		public function get path():String{
			if(section == "")
				return id;
			
			return section + "/" + id;
		}
		
		public function toString():String{
			return path;
		}
	}
}