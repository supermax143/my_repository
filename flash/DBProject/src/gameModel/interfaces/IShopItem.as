package gameModel.interfaces {
	public interface IShopItem {
		function get price():int;
		function get realPrice():int;
		function get isHit():Boolean;
		function get isNew():Boolean;
		function get imageShop():String;
	}
}