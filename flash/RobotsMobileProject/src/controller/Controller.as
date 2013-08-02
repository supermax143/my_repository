package controller
{
	import gameModel.GameModel;
	
	import org.osflash.signals.Signal;

	public class Controller
	{
		
		//--------------------------------------------------------------------------
		//
		//  Static properties
		//
		//--------------------------------------------------------------------------
		
		private static var _instance:Controller;
		
		
		public static function get instance():Controller
		{
			if (!_instance)
			{
				throw new Error("Controller not inited");
				return ;
			}
			
			
			return _instance;
		}
		
		public static function setInstance(controller:Controller,gameModel:GameModel):void
		{
			_instance = controller;
			_instance.model = gameModel;
		}
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var model:GameModel;
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		public var inited:Boolean = false;
		
		//signals
		public var initedSignal:Signal;
		public var loginSignal:Signal;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function Controller()
		{
			if(_instance)
			{
				throw new Error("singltone");
				return ;
			}
			
			initedSignal = new Signal();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		public function init():void
		{
			initedHandler();
		}
		
		public function login(name:String):void
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function initedHandler():void
		{
			inited = true;
			initedSignal.dispatch();
		}
		
	}
}