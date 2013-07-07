package view.dollview.events
{
	import flash.events.Event;
	
	public class PartsManagerEvent extends Event
	{
		public static const PARTS_UPDATED:String = 'partsUpdated'
		
		
		public function PartsManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}