package view.dollview
{
	import dragonBones.factorys.BaseFactory;
	
	import flash.events.Event;
	
	import gameModel.RobotModel;
	
	import view.dollview.events.DollEvent;

	public class BossDoll extends DollBase
	{
		public function BossDoll(type:String)
		{
			super(type);
		}
		
		override protected function factoryInited(factory:BaseFactory):void
		{
			super.factoryInited(factory);
			atackArmature = initArmature("Atack");
			hitArmature = initArmature("Hit");
			deathArmature = initArmature("Death");
			standArmature = initArmature("Stand");
			showStandAnimation();
			dollInitedSignal.dispatch();
		}
		
		override public function set model(value:RobotModel):void
		{
			super.model = value;
			dollUpdatedSignal.dispatch();
		}
		
		
	}
}