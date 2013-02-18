package
{
	import flash.display.Sprite;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	import resources.BunchLoadingItem;
	import resources.ResourceManager;
	import resources.ResourceManagerImpl;
	
	import starling.core.Starling;
	
	
	[SWF(width="700", height="700", frameRate="60", backgroundColor="#000000")]
	public class TrainsStarlingProject extends Sprite
	{
		
		private var mStarling:Starling;
		
		public function TrainsStarlingProject()
		{
			ResourceManager.instance = new ResourceManagerImpl();
			Security.loadPolicyFile("http://stcocos.com.xsph.ru/crossdomain.xml");
			var resources:Array = [];
			addResource(resources, "http://stcocos.com.xsph.ru/static_trains/buildings_resources.swf");
			addResource(resources, "http://stcocos.com.xsph.ru/static_trains/environment_resources.swf");
			addResource(resources, "http://stcocos.com.xsph.ru/static_trains/locomotive_resources.swf"); 
			addResource(resources, "http://stcocos.com.xsph.ru/static_trains/wagon_resources.swf"); 
			addResource(resources, "http://stcocos.com.xsph.ru/static_trains/rails_resources.swf"); 
			addResource(resources, "http://stcocos.com.xsph.ru/static_trains/map_resources.swf"); 
			ResourceManager.instance.loadBunch(resources, onResoursesLoadingProgress, onResoursesLoadingComplete);
		}
		
		private function addResource(out:Array, url:String, shortId:String = null, preventCaching:Boolean = false,
									 isPost:Boolean = false, isBinary:Boolean = false, postData:Object = null):void{
			
			const data:URLVariables = new URLVariables();
			if (postData!=null){
				for(var key:String in postData)
					data[key] = postData[key];
			}
			const item:BunchLoadingItem = new BunchLoadingItem(url, shortId, preventCaching, isPost, isBinary, data);
			out.push(item);
		}
		
		private function onResoursesLoadingProgress(progres:Number):void
		{
			trace(progres);
		}
		
		private function onResoursesLoadingComplete():void
		{
			mStarling = new Starling(TrainsGame,stage)
			mStarling.start();	
		}
		
	}
}