package
{
	import dragonBones.animation.WorldClock;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	
	import utils.ProgressBar;
	
	import view.dollview.DollBase;
	import view.dollview.RobotDoll;
	import view.dollview.events.DollAnimationEvent;
	import view.dollview.events.DollEvent;

	public class Game extends Sprite
	{
		
		private var mLoadingProgress:ProgressBar;
		
		private var doll1:DollBase;
		private var doll2:DollBase;
		
		
		public function Game() 
		{
			addEventListener(Event.ADDED_TO_STAGE,init)
		}
		
		public function start(assets:AssetManager):void
		{
			mLoadingProgress = new ProgressBar(175, 20);
			mLoadingProgress.x = 100//(background.width  - mLoadingProgress.width) / 2;
			mLoadingProgress.y = 100//(background.height - mLoadingProgress.height) / 2;
			addChild(mLoadingProgress);
			
			assets.loadQueue(function(ratio:Number):void
			{
				mLoadingProgress.ratio = ratio;
				
				// a progress bar should always show the 100% for a while,
				// so we show the main menu only after a short delay. 
				
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						mLoadingProgress.removeFromParent(true);
						mLoadingProgress = null;
						init();
					}, 0.15);
			});
			
			
			
		}
		
		private function init():void
		{
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			doll1 = new RobotDoll(DollBase.ROBOT_TYPE);
			doll1.addEventListener(DollEvent.INITED,doll1InitedHandler)
			doll1.x = 250;
			doll1.y = 470;
			doll1.scaleX = -1;
			doll1.addEventListener(TouchEvent.TOUCH,onTouch)
			//onDollTouch = new NativeSignal(doll1,TouchEvent.TOUCH,TouchEvent);
			doll1.addEventListener(DollAnimationEvent.COLLIDE,collideHandler)	
			doll1.useHandCursor = true;	
			
			addChild(doll1);
			
			doll2 = new RobotDoll(DollBase.ROBOT_TYPE);
			doll2.addEventListener(DollEvent.INITED,doll2InitedHandler)
			doll2.x = 620;
			doll2.y = 470;
			addChild(doll2);
		}
		
		
		private function collideHandler(event:DollAnimationEvent):void
		{
			doll2.showAtackReactionAnimation(event.movementId,false);
		}
		
		
		private function doll1InitedHandler(event:DollEvent):void
		{
			doll1.setOpponent(DollBase.ROBOT_TYPE);
		}
		
		private function doll2InitedHandler(event:DollEvent):void
		{
			doll2.setOpponent(DollBase.ROBOT_TYPE);
		}
		
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if(!touch)
				return;
			var actions:Array  = doll1.getAtacksList();
			var actName:String = actions.getItemAt(Math.floor(Math.random()*actions.length)) as String;
			doll1.showAtackAnimation(actName);
		}
		
		private function onEnterFrame(e:Event):void
		{
			WorldClock.clock.advanceTime(-1);
		}
	}
}