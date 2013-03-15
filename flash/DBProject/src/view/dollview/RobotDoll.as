package view.dollview
{
	import dragonBones.Armature;
	import dragonBones.factorys.BaseFactory;
	
	import flash.events.Event;
	
	import gameModel.RobotModel;
	import gameModel.VisualRobotModel;
	
	import resources.ResourceManager;
	
	import view.dollview.events.DollEvent;
	import view.dollview.events.PartsManagerEvent;

	public class RobotDoll extends DollBase
	{
		
		private var _visualModel:VisualRobotModel
		private var partsManager:RobotDollPartsManager;
		
		private var skillsArmarure:Armature;
		
		public var updated:Boolean = true;
		
		public function RobotDoll(type:String)
		{
			super(type);
		}
		
		override protected function factoryInited(factory:BaseFactory):void
		{
			super.factoryInited(factory);
			
			standArmature = initArmature("Animations/Stand");
			showStandAnimation();
			dispatchEvent(new DollEvent(DollEvent.INITED));
		}
		
		override public function setOpponent(type:String):void
		{
			if(opponentType==type)
				return;
			super.setOpponent(type);
			atackArmature = initArmature("Animations/Atack");
			skillsArmarure = initArmature("Animations/Skills");
			if(type.indexOf(DollBase.BOSS_TYPE)!=-1)
			{
				hitArmature = initArmature(type+"/Hit");
				deathArmature = initArmature(type+"/Death");
			}
			else
			{
				hitArmature = initArmature("Animations/Hit");
				deathArmature = initArmature("Animations/Death");
			}
			if(partsManager)
				partsManager.update(_visualModel,armatures);
		}
		
		override public function set model(value:RobotModel):void
		{
			super.model = value;
			visualModel = value.visual;
		}
		
		override protected function get armatures():Array
		{
			var arm:Array = super.armatures;
			arm.push(skillsArmarure);
			return arm;
		}

		public function get visualModel():VisualRobotModel
		{
			return _visualModel;
			
		}

		public function set visualModel(vModel:VisualRobotModel):void
		{
			if(!vModel)
				return;
			if(_visualModel==vModel&&partsManager&&partsManager.isUpdated)
				partsManagerUpdatedHandler();
			
			_visualModel = vModel;
			if(!partsManager)
				partsManager = new RobotDollPartsManager(_visualModel,armatures)
			else
				partsManager.update(_visualModel,armatures);
			
			updated = false;
			if(!partsManager.isUpdated)
				partsManager.addEventListener(PartsManagerEvent.PARTS_UPDATED,partsManagerUpdatedHandler);
			else
				partsManagerUpdatedHandler();
		}
		
		public function showEffectAnimation():void
		{
			playAnimation(skillsArmarure,'heal',true);
			currentArmature = skillsArmarure;
			//_currentArmature.animation.gotoAndPlay('heal');
		}
		
		private function partsManagerUpdatedHandler(event:Event=null):void
		{
			if(event)
				event.target.removeEventListener(PartsManagerEvent.PARTS_UPDATED,partsManagerUpdatedHandler);
			updated = true;
			dispatchEvent(new DollEvent(DollEvent.UPDATED));
		}
		
		
	}
}