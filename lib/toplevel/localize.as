package
{	
	import locale.MultiLang;
	
	/**
	 * Returns a localized string 
	 * 
	 * @value An id representing the value you're requesting: e.g "email" could return "e-mailaccount"
	 * @comment	Something to aid the translators/copywriters during localization/finetuning later on, or something to act as a placeholder until the copy XML gets finalized. e.g "e-mailaccount"
	 * @section A string to help sort and organize localized strings, usually the id of the current page or something
	 */	
	public function localize(value:String, comment:String = "", section:String = ""):String{
		var path:String; 
		
		if(section == ""){
			path = value;
		}else{
			path = section + "/" + value;
		}
		
		if(!MultiLang.instance.pathExists(path)){
			if(comment != "")
				MultiLang.instance.setStringForPath(comment, path);	
			else
				MultiLang.instance.setStringForPath(value, path);	
		}	
		
		return MultiLang.instance.getStringForPath(path);
	}
}