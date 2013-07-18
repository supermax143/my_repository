package gameModel
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class RobotModel extends ModelBase {	
		
		override public function registerData(value:*):void {
			for (var s:* in value){
				if (this.hasOwnProperty(s))
					this["_" + s] = value[s];
			}
			_visualModel = new VisualRobotModel();
			_visualModel.registerData(value);
			dispatchUpdate();
		}
		
		private var _visualModel:VisualRobotModel;
		public function get visual():VisualRobotModel {
			return _visualModel;
		}
		
		private var _mweapon_id:int;
		private var _weapon_id:int;
		private var _damage:int;
		private var _update:String;
		private var _stat_points:int;
		private var _chip1_id:int;
		private var _vk_id:int;
		private var _skill_points:int;
		private var _regen:int;
		private var _level:int;
		private var _chip2_id:int;
		private var _hp:int;
		private var _strength:int;
		private var _template_id:int;
		private var _xp:int;
		private var _garage_level:int;
		private var _tnl:int;

		public function get mweapon_id():int {
			return _mweapon_id;
		}

		public function set mweapon_id(value:int):void {
			_mweapon_id = value;
			dispatchUpdate();
		}

		public function get weapon_id():int {
			return _weapon_id;
		}

		public function set weapon_id(value:int):void {
			_weapon_id = value;
			dispatchUpdate();
		}		

		
		public function get damage():int {
			return _damage;
		}

		public function set damage(value:int):void {
			_damage = value;
			dispatchUpdate();
		}

		public function get update():String {
			return _update;
		}

		public function set update(value:String):void {
			_update = value;
			dispatchUpdate();
		}

		public function get stat_points():int {
			return _stat_points;
		}

		public function set stat_points(value:int):void {
			_stat_points = value;
			dispatchUpdate();
		}		

		public function get chip1_id():int {
			return _chip1_id;
		}

		public function set chip1_id(value:int):void {
			_chip1_id = value;
			dispatchUpdate();
		}

		public function get vk_id():int {
			return _vk_id;
		}

		public function set vk_id(value:int):void {
			_vk_id = value;
			dispatchUpdate();
		}

		public function get skill_points():int {
			return _skill_points;
		}

		public function set skill_points(value:int):void {
			_skill_points = value;
			dispatchUpdate();
		}

		public function get regen():int {
			return _regen;
		}

		public function set regen(value:int):void {
			_regen = value;
			dispatchUpdate();
		}
		
		
		public function get level():int {
			return _level;
		}

		public function set level(value:int):void {
			_level = value;
			dispatchUpdate();
		}

		public function get chip2_id():int {
			return _chip2_id;
		}

		public function set chip2_id(value:int):void {
			_chip2_id = value;
			dispatchUpdate();
		}
		
		
		public function get hp():int {
			return _hp;
		}

		public function set hp(value:int):void {
			_hp = value;
			dispatchUpdate();
		}
		
		public function get strength():int {
			return _strength;
		}

		public function set strength(value:int):void {
			_strength = value;
			dispatchUpdate();
		}

		public function get template_id():int {
			return _template_id;
		}

		public function set template_id(value:int):void {
			_template_id = value;
			dispatchUpdate();
		}

		public function get xp():int {
			return _xp;
		}

		public function set xp(value:int):void {
			_xp = value;
			dispatchUpdate();
		}

		public function get garage_level():int {
			return _garage_level;
		}

		public function set garage_level(value:int):void {
			_garage_level = value;
			dispatchUpdate();
		}
		public function get tnl():int {
			return _tnl;
		}

		public function set tnl(value:int):void {
			_tnl = value;
			dispatchUpdate();
		}
		
		public function get isBoss():Boolean
		{
			return template_id>0?true:false;
		}
		
		public function dealDamage(value:int):void {
			damage = damage - value;
			if (damage < 0) damage = 0; 
			dispatchUpdate();
		}
		
		public function isReady():Boolean {
			return visual.isReady();
		}
		
		public function getItemIdByType(itemType:String, type:String):String {
			switch (itemType) {
				case GameObjectType.WEAPON:
				case GameObjectType.CHIP:
					return this[findItemVarById(itemType, type)];
					break;
				case GameObjectType.STYLE:
				case GameObjectType.PART:
					return visual.getItemIdByType(itemType, type);
			}
			return "";
		}
		
		public function setItemIdByType(itemType:String, type:String, id:String):void {
			switch (itemType) {
				case GameObjectType.WEAPON:
				case GameObjectType.CHIP:
					this[findItemVarById(itemType, type)] = id;
					break;
				case GameObjectType.STYLE:
				case GameObjectType.PART:
					visual.setItemIdByType(itemType, type, id);
			}
			dispatchUpdate();
		}
		
		private function findItemVarById(itemType:String, type:String):String {
			var result:String;
			switch (itemType) {
				case GameObjectType.WEAPON:
					switch (type) {
						case GameObjectType.DAMAGE_TYPE_MELEE:
							result = "_mweapon_id";
							break;
						default:
							result = "_weapon_id";
							break;
					}
					break;
				case GameObjectType.CHIP:
					switch (type) {							
						case "0":
							result = "_chip2_id";
							break;
						default:
							result = "_chip1_id";
							break;
					}
					break;
			}
			return result;
		}
	}
}