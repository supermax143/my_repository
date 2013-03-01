package dollview
{
	import flash.events.Event;
	
	import resources.ResourceManager;

	public class RobotDoll extends Doll
	{
		public function RobotDoll(type:String)
		{
			super(type);
			
		}
		
		override protected function initArmature(event:Event):void
		{
			atackArmature = factory.buildArmature("Animations/Atack");
			hitArmature = factory.buildArmature("Animations/Hit");
			deathArmature = factory.buildArmature("Animations/Death");
			currentArmature = atackArmature;
		}
		
		
	}
}