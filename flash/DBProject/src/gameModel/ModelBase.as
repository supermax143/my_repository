package gameModel
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import gameModel.interfaces.IDataRegister;
	import gameModel.interfaces.IModel;

	public class ModelBase extends EventDispatcher implements IDataRegister {
		public static const UPDATE:String = "ModelBase.Update";
		
		/*public static const READY:String = "ModelBase.Ready";
		public static const UPDATING:String = "ModelBase.Updatning";
		public static const UNDEFINED:String = "ModelBase.UNDEFINED";
		public static const INIT:String = "ModelBase.INIT";
		
		private var _state:String = ModelBase.UNDEFINED; 
		public function get state():String {
			return _state;
		}
		
		public function isReady():Boolean {
			return _state == ModelBase.READY;
		}*/
		
		public function registerData(value:*):void {
			dispatchUpdate();
		}
		
		public function cleanUp():void {
			throw new Error("[ModelBase] cleanUp: this method must be overriden in children");
		}
		
		/*public function update():void {
			_state = ModelBase.UPDATING;
		}
		
		public function init():void {
			_state = ModelBase.INIT;
		}
		
		public function checkReady(checkCallback:Function):void {
			if (checkCallback()) _state = ModelBase.READY;
		}*/
		
		protected function dispatchUpdate():void {
			dispatchEvent(new Event(ModelBase.UPDATE));
		}
	}
}