package resources.events
{
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.events.Event;
	
	import resources.BunchLoadingItem;
	
	public class LoadingItemEvent extends Event
	{
		public static const ITEM_LOADED:String = "itemLoaded"
		
		public var loadingItem:LoadingItem
		
		public function LoadingItemEvent(type:String,loadingItem:LoadingItem,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.loadingItem = loadingItem;
		}
		override public function clone():Event {
			return new LoadingItemEvent(type, loadingItem);
		}
	}
}