package dollview
{
	import dollview.events.DollEvent;
	
	import dragonBones.factorys.BaseFactory;
	
	import flash.events.Event;
	
	import resources.ResourceManager;

	public class RobotDoll extends DollBase
	{
		public function RobotDoll(type:String)
		{
			super(type);
			
		}
		
		override protected function factoryInited(factory:BaseFactory):void
		{
			super.factoryInited(factory);
			atackArmature = factory.buildArmature("Animations/Atack");
			hitArmature = factory.buildArmature("Animations/Hit");
			deathArmature = factory.buildArmature("Animations/Death");
			standArmature = factory.buildArmature("Animations/Stand");
			playStandAnimation();
			dispatchEvent(new DollEvent(DollEvent.INITED));
		}
		
		override public function setOpponent(type:String):void
		{
			if(type.indexOf(DollBase.BOSS_TYPE)!=-1)
			{
				hitArmature = factory.buildArmature(type+"/Hit");
				deathArmature = factory.buildArmature(type+"/Death");
			}
			else
			{
				hitArmature = factory.buildArmature("Animations/Hit");
				deathArmature = factory.buildArmature("Animations/Death");
			}
				
		}
		
		
	}
}