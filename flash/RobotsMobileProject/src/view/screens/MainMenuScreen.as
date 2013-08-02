package view.screens
{
	import com.renaun.controls.VGroup;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	import starling.events.Event;
	
	public class MainMenuScreen extends Screen
	{
		[Event(name="gameScreen",type="starling.events.Event")]
		public static const GAME_SCREEN:String = 'gameScreen';
		
		
		private var buttonsGroup:VGroup;
		private var gameButton:Button;
		
		
		public function MainMenuScreen()
		{
			super();
			
		}
		
		override protected function initialize():void
		{
			super.initialize();
			buttonsGroup = new VGroup();
			gameButton = new Button();
			gameButton.label = 'Play';
			gameButton.addEventListener(Event.TRIGGERED,gameButtonClickHandler);	
			buttonsGroup.addLayoutItem(gameButton)
			addChild(buttonsGroup);
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
			buttonsGroup.x = (actualWidth-buttonsGroup.width)/2
			buttonsGroup.y = (actualHeight-buttonsGroup.height)/2
		}
		
		
		
		private function gameButtonClickHandler(event:Event):void
		{
			dispatchEvent(new Event(GAME_SCREEN));
		}
	}
}