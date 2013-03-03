package dollview
{
	import dollview.events.DollEvent;
	
	import dragonBones.factorys.BaseFactory;
	
	import flash.events.Event;

	public class BossDoll extends Doll
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
			currentArmature = atackArmature;
			dispatchEvent(new DollEvent(DollEvent.INITED));
		}
		
		
	}
}