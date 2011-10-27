package
{
	import framework.config.Config;

	public function get globalURL():String{
		return Config.instance.globalURL;
	}
}