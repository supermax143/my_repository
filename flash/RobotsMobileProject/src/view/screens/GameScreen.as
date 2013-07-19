package view.screens
{
	import com.greensock.TweenMax;
	
	import dragonBones.Bone;
	import dragonBones.animation.WorldClock;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	import utils.CameraManager;
	
	import view.dollview.DollBase;
	import view.dollview.RobotDoll;
	import view.dollview.RobotDollPartsManager;
	import view.particles.ParticleData;
	
	public class GameScreen extends Screen
	{
		
		[Event(name="mainMenu",type="starling.events.Event")]
		public static const MAIN_MENU:String = 'mainMenu';
		
		private var doll1:DollBase;
		private var doll2:DollBase;
		private var backButton:Button;
		private var background:Image;
		
		private var frontParticlesLayer:Sprite;
		
		public function GameScreen()
		{
			super();
			
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			background = new Image(EmbeddedAssets.getTexture("Arena1"));
			addChild(background);
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			doll1 = initDoll();
			if(!doll1.inited)
			{
				doll1.dollInitedSignal.addOnce(dollInitedHandler);
			}
			else
			{
				dollInitedHandler();
			}
			doll2 = initDoll();
			if(!doll2.inited)
			{
				doll2.dollInitedSignal.addOnce(dollInitedHandler);
			}
			else
			{
				dollInitedHandler();
			}
			
			
			backButtonHandler = onBackButton;
			
			backButton = new Button();
			backButton.label = 'Back';
			backButton.addEventListener(Event.TRIGGERED,backButtonClickHandler);
			addChild(backButton);
			
			frontParticlesLayer = new Sprite();
			addChild(frontParticlesLayer);
		}
		
		
		override protected function draw():void
		{
			super.draw();
			doll1.x = 300;
			doll1.y = 470;
			doll1.scaleX = -1;
			
			doll2.x = 670;
			doll2.y = 470;
			
			background.y = actualHeight - background.height;
			background.x = (actualWidth - background.width)/2
		}
		
		private function initDoll():DollBase
		{
			var doll:DollBase = new RobotDoll(DollBase.ROBOT_TYPE);
			doll.addEventListener(TouchEvent.TOUCH,onTouch)
			doll.collisionSignal.add(onDollCollide)	
			doll.showParticleSignal.add(onShowParticle)	
			doll.useHandCursor = true;	
			
			addChild(doll);
			return doll;
		}
		
		
		private function onDollCollide(target:DollBase,animationId:String):void
		{
			var hitTarget:DollBase = target.opponent;
			hitTarget.showAtackReactionAnimation(animationId,false);
			if(animationId == RobotDoll.MELEE_ANIMATION)
			{
				CameraManager.instance.shake(this,2);
			}
			else if(animationId == RobotDoll.KICK_ANIMATION)
			{
				zoomOut(hitTarget.scaleX<0?true:false);
				TweenMax.delayedCall(1.4,function():void{zoomIn()})
			}
				
		}
		
		private function zoomOut(mooveLeft:Boolean):void
		{
				CameraManager.instance.smoothScale(this,1,.78,mooveLeft);
			
		}
		
		private function zoomIn():void
		{
			CameraManager.instance.smoothScale(this,1,1);
			
		}
		
		
		private function onShowParticle(target:DollBase,particle:String,movementId:String):void
		{
			addParticle(ParticleData.init(target,particle,movementId))
		}
		
		
		
		private function dollInitedHandler():void
		{
			if(!doll1||!doll1.inited||!doll2||!doll2.inited)
				return;
				
			doll1.setOpponent(doll2);
			doll2.setOpponent(doll1);
			
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if(!touch)
				return;
			var actions:Vector.<String>  = doll1.getAtacksList();
			var actName:String = actions[Math.floor(Math.random()*(actions.length-1))+1];
			//var actName:String = actions[5];
			(event.currentTarget as DollBase).showAtackAnimation(actName);
		}
		
		private function onEnterFrame(e:Event):void
		{
			WorldClock.clock.advanceTime(-1);
		}
		
		private function addParticle(particleData:ParticleData):void
		{
			if(!particleData)
				return;
			particleData.removeSignal.addOnce(removeParticle);
			for each(var particle:PDParticleSystem in particleData.frontParticles)
			{
				frontParticlesLayer.addChild(particle);
			}
		}
		
		private function removeParticle(particleData:ParticleData):void
		{
			for each(var particle:PDParticleSystem in particleData.frontParticles)
			{
				frontParticlesLayer.removeChild(particle);
				//particle.dispose();
			}
		}
		
		
		private function onBackButton():void
		{
			dispatchEvent(new Event(MAIN_MENU))
		}
		
		private function backButtonClickHandler(event:Event):void
		{
			onBackButton()
		}
		
		
		
		override public function dispose():void
		{
			if(doll1)
			{
				doll1.removeEventListener(TouchEvent.TOUCH,onTouch)
				doll1.collisionSignal.remove(onDollCollide)	
			}
			if(doll2)
			{
				doll2.removeEventListener(TouchEvent.TOUCH,onTouch)
				doll2.collisionSignal.remove(onDollCollide)	
			}
			super.dispose();
		}
	}
}