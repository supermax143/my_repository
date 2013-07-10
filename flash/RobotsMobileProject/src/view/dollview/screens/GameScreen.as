package view.dollview.screens
{
	import dragonBones.animation.WorldClock;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.dollview.DollBase;
	import view.dollview.RobotDoll;
	import view.dollview.events.DollAnimationEvent;
	import view.dollview.events.DollEvent;
	
	public class GameScreen extends Screen
	{
		
		[Event(name="mainMenu",type="starling.events.Event")]
		public static const MAIN_MENU:String = 'mainMenu';
		
		private var doll1:DollBase;
		private var doll2:DollBase;
		private var backButton:Button;
		
		
		public function GameScreen()
		{
			super();
			
			
		}
		
		override protected function initialize():void
		{
			super.initialize();
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			doll1 = new RobotDoll(DollBase.ROBOT_TYPE);
			if(!doll1.inited)
			{
				doll1.addEventListener(DollEvent.INITED,doll1InitedHandler)
			}
			else
			{
				doll1InitedHandler();
			}
			doll1.addEventListener(TouchEvent.TOUCH,onTouch)
			doll1.addEventListener(DollAnimationEvent.COLLIDE,collideHandler)	
			doll1.useHandCursor = true;	
			
			addChild(doll1);
			
			doll2 = new RobotDoll(DollBase.ROBOT_TYPE);
			if(!doll2.inited)
			{
				doll2.addEventListener(DollEvent.INITED,doll2InitedHandler)
			}
			else
			{
				doll2InitedHandler();
			}
			addChild(doll2);
			backButtonHandler = onBackButton;
			
			backButton = new Button();
			backButton.label = 'Back';
			backButton.addEventListener(Event.TRIGGERED,backButtonClickHandler);
			addChild(backButton);
		}
		
		override protected function draw():void
		{
			super.draw();
			doll1.x = 250;
			doll1.y = 470;
			doll1.scaleX = -1;
			
			doll2.x = 620;
			doll2.y = 470;
		}
		
		
		
		
		private function collideHandler(event:DollAnimationEvent):void
		{
			doll2.showAtackReactionAnimation(event.movementId,false);
		}
		
		
		private function doll1InitedHandler(event:DollEvent=null):void
		{
			doll1.setOpponent(DollBase.ROBOT_TYPE);
		}
		
		private function doll2InitedHandler(event:DollEvent=null):void
		{
			doll2.setOpponent(DollBase.ROBOT_TYPE);
		}
		
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if(!touch)
				return;
			var actions:Vector.<String>  = doll1.getAtacksList();
			//var actName:String = actions.getItemAt(Math.floor(Math.random()*actions.length)) as String;
			var actName:String = actions[Math.floor(Math.random()*actions.length)];
			doll1.showAtackAnimation(actName);
		}
		
		private function onEnterFrame(e:Event):void
		{
			WorldClock.clock.advanceTime(-1);
		}
		
		
		private function onBackButton():void
		{
			dispatchEvent(new Event(MAIN_MENU))
			//this.dispatchEventWith(Event.COMPLETE);
		}
		
		private function backButtonClickHandler(event:Event):void
		{
			onBackButton()
		}
	}
}