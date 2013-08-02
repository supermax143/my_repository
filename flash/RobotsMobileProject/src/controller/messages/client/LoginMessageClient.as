package controller.messages.client
{
	public class LoginMessageClient extends MessageClient
	{
		
		public var name:String;
		
		
		public function LoginMessageClient(name:String)
		{
			super(MessageClient.LOGIN);
			this.name = name;
		}
		
		override public function getData():Object
		{
			var obj:Object = 
				{
					name:name
				}
			return obj;
		}
		
		
	}
}