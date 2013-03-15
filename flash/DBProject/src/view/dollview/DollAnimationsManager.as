package view.dollview
{
	import gameModel.battle.actions.CommonActionType;
	
	import library.animations.InitAnimationData;
	
	import mx.collections.ArrayCollection;

	public class DollAnimationsManager
	{
		public static const ROBOT_MELEE_ATACKS:Array = ['punch','kick'];
		public static const ROBOT_MELEE_WEAPON_ATACKS:Array = ['melee'];
		public static const ROBOT_RANGE_WEAPON_ATACKS:Array = ['range_pistol','range_rifle'];	
			
		
		public function DollAnimationsManager()
		{
			
		}
		
		public static function getAtackAnimation(atackId:String,doll:DollBase):String
		{
			if(doll.model.isBoss)
			{
				var atack:String = getBossAtack(doll);
				trace(atack);
				return atack;
			}
			
			switch(atackId)
			{
				case CommonActionType.MELEE:
					return getMeleeAtack(doll);
			}
			return '';
		}
		
		private static function getBossAtack(boss:DollBase):String
		{
			var atacks:Array = [];
			for each(var atack:String in boss.getAtacksList())
				if(atack!='init')
					atacks.push(atack);
			var index:int = Math.floor(Math.random()*atacks.length);
			return atacks[index] as String;
		}
		
		private static function getMeleeAtack(doll:DollBase):String	
		{
			var array:Array = doll.model.mweapon_id==0?ROBOT_MELEE_ATACKS:ROBOT_MELEE_WEAPON_ATACKS;
			var index:int = Math.floor(Math.random()*array.length);
			return array[index];
		}
	}
}