package resources.loader
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	

	public class MainLoader
	{
		//--------------------------------------------------------------------------
		//
		//  Static properties
		//
		//--------------------------------------------------------------------------
		private static var  _instance:MainLoader;
		public static function get instance():MainLoader
		{
			if (!_instance){
				_instance = new MainLoader();
			}
			
			return _instance;
		}
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		private var loader:BulkLoader;
		private var appDomain:ApplicationDomain;
		private var loaderContext:LoaderContext;
		
		private var _maxCacheSize:int;
		
		public function MainLoader()
		{
			if(_instance)
			{
				trace("singletone");
				return;
			}	
			loader = new BulkLoader('TMItemsLoader');
			appDomain = new ApplicationDomain(null);
			loaderContext = new LoaderContext(true, appDomain);
			loader.toString()
		}
		
		public function load(url:String,id:String,preventCaching:Boolean=false):LoadingItem
		{
			var props:Object = {context: loaderContext};
			props["id"] = id;
			props[BulkLoader.PREVENT_CACHING] = preventCaching;
			var loadingItem:LoadingItem =  loader.add(url,props);
			loader.start();
			return loadingItem;
		}
		
		public function showInfo():void
		{
			var info:String = '';
			info+="Total size:"+loader.bytesLoaded/1000+"\n";
			info+="Files Count:"+loader._itemsTotal+"\n";
			trace(info)
		}	
		
		public function removeItem():void
		{
			var items:Array = loader.items;
			if(!items||items.length==0)
				return;
			var loadingItem:LoadingItem = items[0];
			loader.remove(loadingItem._id);
		}	

		public function get maxCacheSize():int
		{
			return _maxCacheSize;
		}

		public function set maxCacheSize(value:int):void
		{
			_maxCacheSize = value;
		}

			
	}
}