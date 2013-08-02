package
{
	import controller.Controller;
	import controller.WebController;
	
	import flash.display.Sprite;
	
	import gameModel.GameModel;
	
	import starling.core.Starling;
	import starling.utils.AssetManager;
	
	[SWF(width="960", height="540", frameRate="60", backgroundColor="#444444")]
	public class RobotsWebProject extends Sprite
	{
		
		public static var instance:RobotsWebProject;
	
		
		private var mStarling:Starling;
		
		public function RobotsWebProject()
		{
			init();
			instance = this;
		}
		
		private function init():void
		{
			
			stage.frameRate = 60;
			// set general properties
			if(!stage||stage.stage3Ds.length==0)
				return;
			var stageWidth:int  = 960;
			var stageHeight:int = 540;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			
		
			// launch Starling
			mStarling = new Starling(Main, stage);
			mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
			mStarling.simulateMultitouch  = true;
			mStarling.enableErrorChecking = false;
			//mStarling.showStats = true;
			
			Controller.setInstance(new WebController(),GameModel.instance);
			Controller.instance.initedSignal.addOnce(mStarling.start)
			Controller.instance.init();
			
		}
		
		
		
	}
}