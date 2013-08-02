package gameModel
{
	public class GameModel
	{
		
		private static var _instance:GameModel;
		
		public static function get instance():GameModel
		{
			if (!_instance)
				return new GameModel();
			return _instance;
		}
		
		
		public function GameModel()
		{
			
		}
	}
}