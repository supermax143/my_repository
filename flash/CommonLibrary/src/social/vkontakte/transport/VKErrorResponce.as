package social.vkontakte.transport
{
public class VKErrorResponce extends VKResponce
{
	public var errorCode:String;
	public var errorMessage:String;
	
	public function VKErrorResponce(data:XML)
	{
		super(data);
		
		if(!data)
			return;
			
		errorCode = data["error_code"];
		errorMessage = data["error_msg"];
	}

}
}