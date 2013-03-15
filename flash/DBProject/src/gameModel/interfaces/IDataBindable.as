package gameModel.interfaces
{
	import flash.events.EventDispatcher;
	
	public interface IDataBindable {
		function setData(value:*):void;
		function getData():*;
	}
}