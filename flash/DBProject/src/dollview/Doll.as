package dollview
{
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import dollview.events.DollEvent;
	
	import dragonBones.Armature;
	import dragonBones.factorys.BaseFactory;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import resources.ResourceManager;

	public class Doll extends Sprite
	{
		public static const ROBOT_TYPE:String = 'Robot'
		public static const BOSS_TYPE:String = 'Boss'
		
		protected var factory:BaseFactory;
		
		protected var atackArmature:Armature;		
		protected var hitArmature:Armature;		
		protected var deathArmature:Armature;
		
		private var _currentArmature:Armature;
		
		private var robot:Sprite;
		
		public function Doll(type:String)
		{
			var resourceData:* = ResourceManager.instance.getBinary(type,false);
			FactoriesManager.addFactory(resourceData,factoryInited);
			addEventListener(Event.ENTER_FRAME,updateAnimation);
		}
		
		protected function factoryInited(factory:BaseFactory):void
		{
			this.factory = factory;
		}
		
		private function updateAnimation(event:Event):void
		{
			if(_currentArmature)
				_currentArmature.update();
		}
		
		protected function set currentArmature(value:Armature):void
		{
			if(_currentArmature==value)
				return;
			_currentArmature = value;
			if(robot)
				removeChild(robot);
			robot = value.display as Sprite;
			addChild(robot);
			_currentArmature.animation.gotoAndPlay('init');
		}
		
		public function atack(atackId:String):void
		{
			currentArmature = atackArmature;
			_currentArmature.animation.gotoAndPlay(atackId);
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
			atackArmature.dispose();
			atackArmature = null;
			hitArmature.dispose();
			hitArmature = null;
			deathArmature.dispose();
			deathArmature = null;
			_currentArmature = null;
		}
			
		
	}
}