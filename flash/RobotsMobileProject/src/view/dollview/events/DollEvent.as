package view.dollview.events
{
	import starling.events.Event;
	
	public class DollEvent extends Event
	{
		
		public static const INITED:String = 'inited';
		public static const UPDATED:String = 'updated';
		
		
		public function DollEvent(type:String,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			
			super(type, bubbles, cancelable);
		}
	}
}