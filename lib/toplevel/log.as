package
{
	import flash.external.ExternalInterface;

	public function log(value:*):void{
		if(value as String){
			ExternalInterface.call("console.log", value);
		}
		
		trace(value);
	}
}