package dollview
{
	import dollview.events.DollEvent;
	
	import dragonBones.factorys.BaseFactory;
	
	import flash.events.Event;
	
	import resources.ResourceManager;

	public class RobotDoll extends Doll
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
			currentArmature = atackArmature;
			dispatchEvent(new DollEvent(DollEvent.INITED));
		}
		
		
	}
}