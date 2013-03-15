package gameModel.interfaces
{
	public interface IRotated extends IDataBindable {
		function setTime(value:Number):void;
		function getTime():Number;
		function updateTime(dValue:Number):void;
		function dispatchComplete():void;
		function dispatchUpdate():void;
	}
}