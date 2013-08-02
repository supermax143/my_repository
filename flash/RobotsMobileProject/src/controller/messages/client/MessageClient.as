package controller.messages.client
{
	public class MessageClient
	{
		
		public static const LOGIN:String = 'login';
		
		public var type:String
		
		public function MessageClient(type:String)
		{
			this.type = type;	
		}
		
		public function getData():Object
		{
			return {};
		}
	}
}