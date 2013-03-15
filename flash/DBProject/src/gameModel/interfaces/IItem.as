package gameModel.interfaces {
	public interface IItem extends IShopItem {
		function get itemType():String;
		function get type():String;
		function get id():String;
		function get title():String;
		function get description():String;
		/*function get price():int;
		function get realPrice():int;
		function get isHit():Boolean;
		function get isNew():Boolean;
		function get imageShop():String;*/
	}
}