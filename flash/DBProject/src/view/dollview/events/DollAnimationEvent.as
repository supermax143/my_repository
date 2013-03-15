package view.dollview.events
{
	import flash.events.Event;
	
	public class DollAnimationEvent extends Event
	{
		public static const COLLIDE:String = 'collide';
		public static const ANIMATION_COMPLETE:String = 'animationComplete';
		
		public var movementId:String = '';
		
		public function DollAnimationEvent(type:String, movementId:String='', bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.movementId = movementId;
			super(type, bubbles, cancelable);
		}
	}
}