package gameModel
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import gameModel.interfaces.IDataRegister;
	import gameModel.interfaces.IModel;

	public class ModelBase extends EventDispatcher implements IDataRegister {
		public static const UPDATE:String = "ModelBase.Update";
		
		
		public function registerData(value:*):void {
			dispatchUpdate();
		}
		
		public function cleanUp():void {
			throw new Error("[ModelBase] cleanUp: this method must be overriden in children");
		}
		
		protected function dispatchUpdate():void {
			dispatchEvent(new Event(ModelBase.UPDATE));
		}
	}
}