package gameModel
{
	public class VisualRobotModel extends ModelBase {
		override public function registerData(value:*):void {
			for (var s:* in value){
				if (this.hasOwnProperty(s))
					this["_" + s] = value[s];
			}
			dispatchUpdate();
		}
		
		private var _head_id:int;
		private var _body_id:int;
		private var _arms_id:int;
		private var _legs_id:int;
		private var _style_id:int;
		
		public function get head_id():int{
			return _head_id;
		}
		
		public function set head_id(value:int):void{
			_head_id = value;
			dispatchUpdate();
		}
		
		public function get body_id():int{
			return _body_id;
		}
		
		public function set body_id(value:int):void {
			_body_id = value;
			dispatchUpdate();
		}		
		
		public function get arms_id():int {
			return _arms_id;
		}
		
		public function set arms_id(value:int):void {
			_arms_id = value;
			dispatchUpdate();
		}
		
		public function get style_id():int {
			return _style_id;
		}
		
		public function set style_id(value:int):void {
			_style_id = value;
			dispatchUpdate();
		}			
		
		public function get legs_id():int {
			return _legs_id;
		}
		
		public function set legs_id(value:int):void {
			_legs_id = value;
			dispatchUpdate();
		}
		
		public function isReady():Boolean {
			if (this.legs_id <= 0) return false;
			if (this.arms_id <= 0) return false;
			if (this.head_id <= 0) return false;
			if (this.body_id <= 0) return false;
			if (this.style_id <=0) return false;
			return true;
		}
		
		public function getItemIdByType(itemType:String, type:String):String {
			return this[findItemVarById(itemType, type)];
		}
		
		public function setItemIdByType(itemType:String, type:String, id:String):void {
			this[findItemVarById(itemType, type)] = id;
			dispatchUpdate();
		}
		
		private function findItemVarById(itemType:String, type:String):String {
			var result:String;
			switch (itemType) {
				case GameObjectType.PART:
					switch (type) {
						case PartsType.LEGS:
							result = "_legs_id";
							break;
						case PartsType.ARM:
							result = "_arms_id";
							break;
						case PartsType.HEAD:
							result = "_head_id";
							break;
						case PartsType.BODY:
							result = "_body_id";
							break;
					}
					break;				
				case GameObjectType.STYLE:
					result = "_style_id";
					break;
			}
			return result;
		}
	}
}