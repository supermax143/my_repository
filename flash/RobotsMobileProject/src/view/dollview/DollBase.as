package view.dollview
{
	import dragonBones.Armature;
	import dragonBones.animation.WorldClock;
	import dragonBones.events.AnimationEvent;
	import dragonBones.events.FrameEvent;
	import dragonBones.factorys.BaseFactory;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLVariables;
	
	import gameModel.RobotModel;
	
	import resources.BunchLoadingItem;
	import resources.ResourceManager;
	
	import starling.display.Sprite;
	
	import view.dollview.events.DollAnimationEvent;
	import view.dollview.events.DollEvent;

	public class DollBase extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Static properties
		//
		//--------------------------------------------------------------------------
		public static const ROBOT_TYPE:String = 'Robot'
		public static const BOSS_TYPE:String = 'Boss'
		public static const RESOURCES_URL:String = 'http://stcocos.com.xsph.ru/static_robots/swf/'	
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		private var _currentArmature:Armature;
		private var robot:Sprite;
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------	
			
		protected var _model:RobotModel
		protected var factory:BaseFactory;
		protected var atackArmature:Armature;		
		protected var hitArmature:Armature;		
		protected var deathArmature:Armature;
		protected var standArmature:Armature;
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		public var inited:Boolean = false;
		public var type:String = '';
		public var opponentType:String = '';
		private var _animationSpeed:Number = 1;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function DollBase(type:String)
		{
			this.type = type;
			var res:Array = [];
			//addResource(res,RESOURCES_URL+type+"_output.swf",type,false,false,true);
			onResoursesLoadingComplete();
		}
		
		private function addResource(out:Array, url:String, shortId:String = null, preventCaching:Boolean = false,
									 isPost:Boolean = false, isBinary:Boolean = false, postData:Object = null):void {
			
			const data:URLVariables = new URLVariables();
			if (postData!=null){
				for(var key:String in postData)
					data[key] = postData[key];
			}
			const item:BunchLoadingItem = new BunchLoadingItem(url, shortId, preventCaching, isPost, isBinary, data);
			out.push(item);
		}
		
		private function onResoursesLoadingProgress(progress:Number):void {
			trace(String(progress));
		}
		
		private function onResoursesLoadingComplete():void {
			//var resourceData:* = ResourceManager.instance.getBinary(type,false);
			var resourceData:* = EmbeddedAssets.Robot_output;
			FactoriesManager.addFactory(EmbeddedAssets.Robot_output,factoryInited);
		}
		
		private function onResoursesLoadingError(e:ErrorEvent):void {
			
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  StaticMethods
		//
		//--------------------------------------------------------------------------
		
		public static function createRobot(model:RobotModel,resultHandler:Function):void
		{
			var doll:DollBase = new RobotDoll(ROBOT_TYPE);
			if(doll.inited)
			{
				dollInited(doll,model,resultHandler);
			}
			else
			{
				doll.addEventListener(DollEvent.INITED,
					function inited(event:Event):void
					{
						doll.removeEventListener(DollEvent.INITED,inited);
						dollInited(doll,model,resultHandler);
					})
			}
		}
		
		public static function createBoss(bossId:int,model:RobotModel,resultHandler:Function):void
		{
			var doll:DollBase = new BossDoll(BOSS_TYPE+bossId);
			if(doll.inited)
			{
				dollInited(doll,model,resultHandler);
			}
			else
			{
				doll.addEventListener(DollEvent.INITED,
					function inited(event:Event):void
					{
						doll.removeEventListener(DollEvent.INITED,inited);
						dollInited(doll,model,resultHandler);
					})
					
			}
		}
		
		private static function dollInited(doll:DollBase,model:RobotModel,resultHandler:Function):void
		{
			if(!model)
			{
				resultHandler(doll);
				return;
			}
			doll.addEventListener(DollEvent.UPDATED,
				function robotUpdated(event:Event):void
				{
					doll.removeEventListener(DollEvent.INITED,robotUpdated);
					resultHandler(doll);
				});
			doll.model = model;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
	
		private function handleAnimationEvents(event:FrameEvent):void
		{
			switch(event.frameLabel)
			{
				case 'collision':
					dispatchEvent(new DollAnimationEvent(DollAnimationEvent.COLLIDE,event.movementID));
					break;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected Methods
		//
		//--------------------------------------------------------------------------
		protected function factoryInited(factory:BaseFactory):void
		{
			this.factory = factory;
			inited = true;
		}
		
		
		protected function initArmature(armatureName:String):Armature
		{
			var armature:Armature = factory.buildArmature(armatureName);
			//for each(var anim:String in armature.animation.movementList)
			//	playAnimation(armature,anim,false);
			return armature;
		}
		
		
		protected function set currentArmature(value:Armature):void
		{
			if(_currentArmature==value||!value)
				return;
			
			if(_currentArmature)
				WorldClock.clock.remove(_currentArmature);
			
			_currentArmature = value;
			if(!_currentArmature.hasEventListener(FrameEvent.MOVEMENT_FRAME_EVENT))
				_currentArmature.addEventListener(FrameEvent.MOVEMENT_FRAME_EVENT,handleAnimationEvents)
			if(robot)
				removeChild(robot);
			robot = value.display as Sprite;
			addChild(robot);
			
			_currentArmature.animation.timeScale = _animationSpeed;
			WorldClock.clock.add(_currentArmature);
		}
		
		protected function get armatures():Array
		{
			
			return [atackArmature,hitArmature,deathArmature,standArmature]
		}
		
		
		protected function animationCompleteHandler(event:AnimationEvent):void
		{
			var armature:Armature = event.target as Armature;
			armature.removeEventListener(AnimationEvent.COMPLETE,animationCompleteHandler);
			if(armature.name.indexOf('Death')==-1)
				showStandAnimation();
			dispatchEvent(new DollAnimationEvent(DollAnimationEvent.ANIMATION_COMPLETE,event.movementID))
		}
		
		protected function playAnimation(armature:Armature,animationName:String,showStandAfterComplate:Boolean):void
		{
			currentArmature = armature;
			_currentArmature.animation.gotoAndPlay(animationName);
			if(showStandAfterComplate)
				_currentArmature.addEventListener(AnimationEvent.COMPLETE,animationCompleteHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		public function get animationSpeed():Number
		{
			return _animationSpeed;
		}
		
		public function set animationSpeed(value:Number):void
		{
			_animationSpeed = value;
			if(_currentArmature)
				_currentArmature.animation.timeScale = _animationSpeed;
		}

		
		public function setOpponent(type:String):void
		{
			opponentType = type;
		}
		
		public function freeze():void
		{
			_currentArmature.animation.stop();
		}
		
		public function showAtackAnimation(atackId:String):void
		{
			playAnimation(atackArmature,atackId,true);
		}
		
		public function showAtackReactionAnimation(atackId:String,death:Boolean):void
		{
			
			var armature:Armature = death?deathArmature:hitArmature;
			playAnimation(armature,atackId,true);
		}
		
		public function showStandAnimation():void
		{
			currentArmature = standArmature;
			if(!_currentArmature.animation.isPlaying)
			{
				_currentArmature.animation.gotoAndPlay('stand1',-1,-1,true)
			}
			//playAnimation(standArmature,'stand1',true);
		}
		
		
		public function getAtacksList():Vector.<String>
		{
			
			return atackArmature.animation.movementList;	
		}
		
		override public function dispose():void
		{
			_currentArmature.removeEventListener(FrameEvent.MOVEMENT_FRAME_EVENT,handleAnimationEvents)
			if(atackArmature)	
				atackArmature.dispose();
			atackArmature = null;
			if(hitArmature)
				hitArmature.dispose();
			hitArmature = null;
			if(deathArmature)
				deathArmature.dispose();
			deathArmature = null;
			if(standArmature)
				standArmature.dispose();
			standArmature = null;
			if(_currentArmature)
				WorldClock.clock.remove(_currentArmature);
			_currentArmature = null;
			super.dispose();
		}

		public function get model():RobotModel
		{
			return _model;
		}

		public function set model(value:RobotModel):void
		{
			_model = value;
		}
			
		
	}
}