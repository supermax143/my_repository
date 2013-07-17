package view.screens
{
	import dragonBones.Bone;
	import dragonBones.animation.WorldClock;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	import view.dollview.DollBase;
	import view.dollview.RobotDoll;
	import view.dollview.RobotDollPartsManager;
	import view.dollview.events.DollEvent;
	import view.particles.ParticleData;
	import view.particles.ParticlesManager;
	
	public class GameScreen extends Screen
	{
		
		[Event(name="mainMenu",type="starling.events.Event")]
		public static const MAIN_MENU:String = 'mainMenu';
		
		private var doll1:DollBase;
		private var doll2:DollBase;
		private var backButton:Button;
		private var particlesManager:ParticlesManager;
		
		public static var hitParticle:PDParticleSystem;
		
		private var particlesLayer:Sprite;
		
		public function GameScreen()
		{
			super();
			particlesManager = new ParticlesManager();
			particlesManager.addParticleSignal.add(onParticleAdded)
			particlesManager.removeParticleSignal.add(onParticleRemoved)
			particlesLayer = new Sprite();
			addChild(particlesLayer);
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
			doll1.collisionSignal.add(onDollCollide)	
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
			doll2.addEventListener(TouchEvent.TOUCH,onTouch)
			doll2.collisionSignal.add(onDollCollide)	
			doll2.useHandCursor = true;	
			addChild(doll2);
			backButtonHandler = onBackButton;
			
			backButton = new Button();
			backButton.label = 'Back';
			backButton.addEventListener(Event.TRIGGERED,backButtonClickHandler);
			addChild(backButton);
			hitParticle = new PDParticleSystem(XML(new ParticleAssets.ParticleCoffeeXML()), Texture.fromBitmap(new ParticleAssets.CircleParticleTexture()));
			Starling.juggler.add(hitParticle);
			addChild(hitParticle);
		}
		
		override protected function draw():void
		{
			super.draw();
			doll1.x = 300;
			doll1.y = 470;
			doll1.scaleX = -1;
			
			doll2.x = 670;
			doll2.y = 470;
		}
		
		
		private function onDollCollide(target:DollBase,movementId:String):void
		{
			var hitTarget:DollBase = target.opponent;
			hitTarget.showAtackReactionAnimation(movementId,false);
			var bone:Bone = hitTarget.getBone(RobotDollPartsManager.HEAD_BONE);
			hitParticle.emitterX = hitTarget.x+bone.origin.x;
			hitParticle.emitterY = hitTarget.y+bone.origin.y;
			hitParticle.maxNumParticles = 200;
			hitParticle.emitAngle = hitTarget.scaleX>0?180:0;
			hitParticle.start(.2);
		}
		
		
		private function doll1InitedHandler(event:DollEvent=null):void
		{
			if(doll2.inited)
				setOpponents();
			
		}
		
		private function doll2InitedHandler(event:DollEvent=null):void
		{
			if(doll1.inited)
				setOpponents();
			
		}
		
		private function setOpponents():void
		{
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
			(event.currentTarget as DollBase).showAtackAnimation(actName);
		}
		
		private function onEnterFrame(e:Event):void
		{
			WorldClock.clock.advanceTime(-1);
		}
		
		private function onParticleAdded(particleData:ParticleData):void
		{
			
		}
		
		private function onParticleRemoved(particleData:ParticleData):void
		{
			
		}
		
		
		private function onBackButton():void
		{
			dispatchEvent(new Event(MAIN_MENU))
		}
		
		private function backButtonClickHandler(event:Event):void
		{
			onBackButton()
		}
	}
}