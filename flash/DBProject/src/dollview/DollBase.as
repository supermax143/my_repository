package dollview
{
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import dollview.events.DollEvent;
	
	import dragonBones.Armature;
	import dragonBones.events.AnimationEvent;
	import dragonBones.events.FrameEvent;
	import dragonBones.factorys.BaseFactory;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import resources.ResourceManager;

	public class DollBase extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Static properties
		//
		//--------------------------------------------------------------------------
		public static const ROBOT_TYPE:String = 'Robot'
		public static const BOSS_TYPE:String = 'Boss'
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
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function DollBase(type:String)
		{
			this.type = type;
			var resourceData:* = ResourceManager.instance.getBinary(type,false);
			FactoriesManager.addFactory(resourceData,factoryInited);
			addEventListener(Event.ENTER_FRAME,updateAnimation);
		}
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		private function updateAnimation(event:Event):void
		{
			if(_currentArmature)
				_currentArmature.update();
		}
		
		private function handleAnimationEvents(event:FrameEvent):void
		{
			switch(event.frameLabel)
			{
				case 'collision':
					dispatchEvent(new DollEvent(DollEvent.COLLIDE,event.movementID));
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
		
		protected function set currentArmature(value:Armature):void
		{
			if(_currentArmature==value||!value)
				return;
			
			_currentArmature = value;
			if(!_currentArmature.hasEventListener(FrameEvent.MOVEMENT_FRAME_EVENT))
				_currentArmature.addEventListener(FrameEvent.MOVEMENT_FRAME_EVENT,handleAnimationEvents)
			if(robot)
				removeChild(robot);
			robot = value.display as Sprite;
			addChild(robot);
			
			_currentArmature.animation.gotoAndPlay('init');
			
			
		}
		
		protected function playStandAnimation():void
		{
			currentArmature = standArmature;
			_currentArmature.animation.gotoAndPlay('stand1',2,-1,true)
		}
		
		protected function animationCompleteHandler(event:AnimationEvent):void
		{
			event.target.removeEventListener(AnimationEvent.COMPLETE,animationCompleteHandler);
			playStandAnimation();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		
		public function setOpponent(type:String):void
		{
			
		}
		
		
		public function atack(atackId:String):void
		{
			currentArmature = atackArmature;
			_currentArmature.animation.gotoAndPlay(atackId,2,-1);
			_currentArmature.addEventListener(AnimationEvent.COMPLETE,animationCompleteHandler);
		}
		
		public function atackReaction(atackType:String,death:Boolean):void
		{
			currentArmature = death?deathArmature:hitArmature;
			_currentArmature.animation.gotoAndPlay(atackType);
			if(!death)
				_currentArmature.addEventListener(AnimationEvent.COMPLETE,animationCompleteHandler);
		}
		
		public function getAtacksList():ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for each (var atack:String in atackArmature.animation.movementList) 
				arr.addItem(atack);
			return arr;	
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME,updateAnimation);
			_currentArmature.removeEventListener(FrameEvent.MOVEMENT_FRAME_EVENT,handleAnimationEvents)
			atackArmature.dispose();
			atackArmature = null;
			hitArmature.dispose();
			hitArmature = null;
			deathArmature.dispose();
			deathArmature = null;
			standArmature.dispose();
			standArmature = null;
			_currentArmature = null;
		}
			
		
	}
}