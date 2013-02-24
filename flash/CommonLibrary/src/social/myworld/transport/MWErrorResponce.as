package social.myworld.transport
{
public class MWErrorResponce extends MWResponce
{
	public var errorCode:String;
	public var errorMessage:String;
	
	public function MWErrorResponce(data:XML)
	{
		super(data);
		if(!data)
			return;
		errorCode = data["error_code"];
		errorMessage = data["error_msg"];
	}
}
}