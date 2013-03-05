package dollview
{
	import dollview.events.DollEvent;
	
	import dragonBones.factorys.BaseFactory;
	
	import flash.events.Event;

	public class BossDoll extends DollBase
	{
		public function BossDoll(type:String)
		{
			super(type);
		}
		
		override protected function factoryInited(factory:BaseFactory):void
		{
			super.factoryInited(factory);
			atackArmature = factory.buildArmature("Atack");
			hitArmature = factory.buildArmature("Hit");
			deathArmature = factory.buildArmature("Death");
			standArmature = factory.buildArmature("Stand");
			playStandAnimation();
			dispatchEvent(new DollEvent(DollEvent.INITED));
		}
		
		
	}
}