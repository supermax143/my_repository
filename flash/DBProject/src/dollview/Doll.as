package dollview
{
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import dragonBones.Armature;
	import dragonBones.factorys.BaseFactory;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	
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
			factory = new BaseFactory();
			var resourceData:* = ResourceManager.instance.getBinary(type,false);
			factory.parseData(resourceData);
			factory.addEventListener(Event.COMPLETE, initArmature);
			addEventListener(Event.ENTER_FRAME,updateAnimation);
		}
		
		private function updateAnimation(event:Event):void
		{
			if(_currentArmature)
				_currentArmature.update();
		}
		
		protected function initArmature(event:Event):void
		{
			throw new Error('method must be overriden');
		}
		
		public function set currentArmature(value:Armature):void
		{
			_currentArmature = value;
			if(robot)
				removeChild(robot);
			robot = value.display as Sprite;
			addChild(robot);
			_currentArmature.animation.gotoAndPlay('init');
		}
		
	}
}