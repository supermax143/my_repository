package
{
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.net.URLVariables;
	
	import graphics.GraphixUtils;
	
	import resources.BunchLoadingItem;
	import resources.ResourceManager;

	[Bindable]
	public class RobotPartsContainer
	{
		
		private var serverURL:String='http://stcocos.com.xsph.ru/static_robots/item/';
		public var imgPath:Vector.<String>=new Vector.<String>();
		public var imgArr:Vector.<MovieClip>=new Vector.<MovieClip>();
		
		public var name:String;
		
		public function RobotPartsContainer(name:String,_style:String,_head:String,_body:String,_arm:String,_foot:String,_finger:String)
		{
			this.name = name;
			var _style:String = '0';
			var _head:String = '31';
			var _body:String = '41';
			var _arm:String = '21';
			var _foot:String = '12';
			var _finger:String = '3';
			
			
			imgPath=new <String>[serverURL+'head/'+_head+'/'+_style+'/head.swf',
				serverURL+'body/'+_body+'/'+_style+'/body.swf',
				serverURL+'body/'+_body+'/'+_style+'/pelvis.swf',
				serverURL+'arm/'+_arm+'/'+_style+'/leftHand.swf',
				serverURL+'arm/'+_arm+'/'+_style+'/rightHand.swf',
				serverURL+'arm/'+_arm+'/'+_style+'/leftArm.swf',
				serverURL+'arm/'+_arm+'/'+_style+'/rightArm.swf',
				serverURL+'foot/'+_foot+'/'+_style+'/leftFoot.swf',
				serverURL+'foot/'+_foot+'/'+_style+'/rightFoot.swf',
				serverURL+'foot/'+_foot+'/'+_style+'/leftThigh.swf',
				serverURL+'foot/'+_foot+'/'+_style+'/rightThigh.swf',
				serverURL+'foot/'+_foot+'/'+_style+'/heel.swf',
				serverURL+'foot/'+_foot+'/'+_style+'/heel.swf',
				serverURL+'finger/'+_finger+'.swf'];
			loadResources();
		}
		
		
		
		private function loadResources():void {
			var res:Array = [];
			for each(var url:String in imgPath)
			addResource(res, url);
			
			ResourceManager.instance.loadBunch(res, onResoursesLoadingProgress, onResoursesLoadingComplete, onResoursesLoadingError);
		}
		
		private function addResource(out:Array, url:String, shortId:String = null, preventCaching:Boolean = false,
									 isPost:Boolean = false, isBinary:Boolean = false, postData:Object = null):void {
			const data:URLVariables = new URLVariables();
			if (postData!=null){
				for(var key:String in postData)
					data[key] = postData[key];
			}
			const item:BunchLoadingItem = new BunchLoadingItem(url, shortId, preventCaching, isPost, isBinary, data);
			out.push(item);
		}
		
		private function onResoursesLoadingProgress(progress:Number):void {
			trace(String(progress));
		}
		
		private function onResoursesLoadingComplete():void {
			addRobotParts();
			trace("Resources is loaded");
		}
		
		
		
		private function onResoursesLoadingError(e:ErrorEvent):void {
			addRobotParts();
			trace("Not all parts loaded");
		}
		
		private function addRobotParts():void
		{
			for each(var url:String in imgPath)
			{
				var loadingItem:LoadingItem = ResourceManager.instance.getLoadingItem(url);
				if(!loadingItem.content)
				{
					imgArr.push(new MovieClip());
					continue;
				}
				
				var part:MovieClip = loadingItem.content as MovieClip;
				var bitMap:DisplayObject = GraphixUtils.convertToBitmap(part);
				var mc:MovieClip = new MovieClip(); 
				mc.addChild(bitMap)
				imgArr.push(mc);
			}
		}
		
		public function get golovaImage():MovieClip
		{
			return imgArr[0];
		}
		
		public function get torsImage():MovieClip
		{
			return imgArr[1];
		}
		
		/*imgPath=new <String>[serverURL+'head/'+_head+'/'+_style+'/head.swf',
			serverURL+'body/'+_body+'/'+_style+'/body.swf',
			serverURL+'body/'+_body+'/'+_style+'/pelvis.swf',
			serverURL+'arm/'+_arm+'/'+_style+'/leftHand.swf',
			serverURL+'arm/'+_arm+'/'+_style+'/rightHand.swf',
			serverURL+'arm/'+_arm+'/'+_style+'/leftArm.swf',
			serverURL+'arm/'+_arm+'/'+_style+'/rightArm.swf',
			serverURL+'foot/'+_foot+'/'+_style+'/leftFoot.swf',
			serverURL+'foot/'+_foot+'/'+_style+'/rightFoot.swf',
			serverURL+'foot/'+_foot+'/'+_style+'/leftThigh.swf',
			serverURL+'foot/'+_foot+'/'+_style+'/rightThigh.swf',
			serverURL+'foot/'+_foot+'/'+_style+'/heel.swf',
			serverURL+'foot/'+_foot+'/'+_style+'/heel.swf',
			serverURL+'finger/'+_finger+'.swf'];
		loadResources();*/
		
	}
}