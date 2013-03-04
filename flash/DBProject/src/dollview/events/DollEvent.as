package dollview.events
{
	import flash.events.Event;
	
	public class DollEvent extends Event
	{
		
		public static const INITED:String = 'inited';
		public static const COLLIDE:String = 'collide';
		
		public var movementId:String = '';
		
		public function DollEvent(type:String,movementId:String='',bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.movementId = movementId;
			super(type, bubbles, cancelable);
		}
	}
}