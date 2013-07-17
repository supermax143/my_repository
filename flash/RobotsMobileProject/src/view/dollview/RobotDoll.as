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
		
		override public function setOpponent(opponent:DollBase):void
		{
			if(this.opponent==opponent)
				return;
			super.setOpponent(opponent);
			atackArmature = initArmature("Animations/Atack");
			skillsArmarure = initArmature("Animations/Skills");
			if(opponent.type.indexOf(DollBase.BOSS_TYPE)!=-1)
			{
				hitArmature = initArmature(opponent.type+"/Hit");
				deathArmature = initArmature(opponent.type+"/Death");
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
		
		public function showEffectAnimation(animationId:String):void
		{
			currentArmature = skillsArmarure;
			playAnimation(skillsArmarure,animationId,true);
			//_currentArmature.animation.gotoAndPlay('heal');
		}
		
		public function getEffectsList():Array
		{
			var arr:Array = [];
			if(!atackArmature)
				return new [];
			for each (var skill:String in skillsArmarure.animation.movementList) 
				arr.addItem(skill);
			return arr;	
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