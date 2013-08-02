package controller.messages.server
{
	import flash.utils.Dictionary;

	public class MessageServer
	{
		
		public static const MESSAGES_DICTIONARY:Dictionary<Class> = 
			[
				'battleAction':BattleActionMessage
			];
		
		
		public static function create(data:Object):MessageServer
		{
			
		}
		
		
		public function MessageServer()
		{
			
		}
		
		
		
	}
}