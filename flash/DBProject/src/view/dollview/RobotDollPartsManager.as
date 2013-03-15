package view.dollview
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import dragonBones.Armature;
	import dragonBones.Bone;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import gameModel.VisualRobotModel;
	
	import graphics.GraphixUtils;
	
	import mx.controls.Alert;
	
	import resources.ResourceManager;
	
	import view.dollview.events.PartsManagerEvent;

	internal class RobotDollPartsManager extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Static properties
		//
		//--------------------------------------------------------------------------
		private static const HEAD_BONE:String = 'golova';
		private static const BODY_BONE:String = 'tors';
		private static const PELVIS_BONE:String = 'taz';
		
		private static const LEFT_ARM_BONE:String = 'plecho 1';
		private static const LEFT_HAND_BONE:String = 'predpl 1';
		private static const RIGHT_ARM_BONE:String = 'plecho 2';
		private static const RIGHT_HAND_BONE:String = 'predpl 2';
		
		private static const LEFT_THIGH_BONE:String = 'bedro 1';
		private static const LEFT_FOOT_BONE:String = 'golen 1';
		
		private static const RIGHT_THIGH_BONE:String = 'bedro 2';
		private static const RIGHT_FOOT_BONE:String = 'golen 2';
		
		private static const HEEL_BONE:String = 'stopa';
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		private var serverURL:String = ''
		
		private var partsDictionary:Dictionary;	
		public var armatures:Array;
		private var model:VisualRobotModel;
		
		private var loadingParts:int = 0;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function RobotDollPartsManager(model:VisualRobotModel,armatures:Array)
		{
			serverURL// = Main.game.user.staticURL;
			partsDictionary = new Dictionary(true)
			this.armatures = armatures;
			this.model = model;
			updateParts(armatures);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private function updateParts(armatures:Array):void
		{
			this.armatures = armatures;
			updateHead(model.head_id,model.style_id);
			updateBody(model.body_id,model.style_id);
			updateArms(model.arms_id,model.style_id);
			updateLegs(model.legs_id,model.style_id);
		}
		
		private function createUrl(partName:String,partId:int,styleId:int,fileName:String):String
		{
			return serverURL+'item/'+partName+'/'+partId+'/'+styleId+'/'+fileName+'.swf'
		}
		
		private function loadPart(url:String,boneName:String):void
		{
			loadingParts++;
			var props:Object = new Object();;
			props[BulkLoader.PREVENT_CACHING] = false;
			var loadingItem:LoadingItem// = ResourceManager.instance.addLoadingIte(url,props);
			partsDictionary[loadingItem]=boneName;
			if(!loadingItem.isLoaded)
			{
				loadingItem.addEventListener(Event.COMPLETE,partLoadedHandler);
			}
			else
			{
				updatePart(loadingItem);
			}
		}
		
		private function partLoadedHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE,partLoadedHandler);
			updatePart(event.target as LoadingItem);
		}
		
		private function updatePart(loadingItem:LoadingItem):void
		{
			loadingParts--;
			var boneName:String = partsDictionary[loadingItem];
			var partImage:DisplayObject;
			for each(var armature:Armature in armatures)
			{
				if(!armature)
					continue;
				partImage = GraphixUtils.convertToBitmap(loadingItem.content);
				
				var bone:Bone = armature.getBone(boneName);
				if(bone)
				{
					if(boneName==LEFT_FOOT_BONE||boneName==RIGHT_FOOT_BONE)
					{
						var boneDispaly:DisplayObjectContainer = (bone.display as DisplayObjectContainer)
						var child:DisplayObject = boneDispaly.getChildAt(0);
						var rect:Rectangle = child.getRect(child);
						partImage.x = 13.5//rect.x;
						//partImage.y = rect.y;
					}
					var partContainer:Sprite = new Sprite();
					partContainer.addChild(partImage);
					bone.display = partContainer;
					//armature.update();
				}
				else if(boneName==HEEL_BONE)
				{
					partImage = GraphixUtils.convertToBitmap(loadingItem.content);
					var bone1:Bone = armature.getBone(boneName+' 1');
					partContainer = new Sprite();
					partContainer.addChild(GraphixUtils.convertToBitmap(partImage));
					bone1.display = partContainer;
					
					var bone2:Bone = armature.getBone(boneName+' 2');
					partContainer = new Sprite();
					partContainer.addChild(GraphixUtils.convertToBitmap(partImage));
					bone2.display = partContainer;
				}
					
			}
			if(loadingParts==0)
				dispatchEvent(new PartsManagerEvent(PartsManagerEvent.PARTS_UPDATED))
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------	
		public function update(model:VisualRobotModel,armatures:Array):void
		{
			if(model)
				this.model = model;
			updateParts(armatures);
		}
		
		public function updateHead(id:int,styleId:int):void
		{
			
			var url:String = createUrl('head',id,styleId,'head');
			loadPart(url,HEAD_BONE);
		}
		
		public function updateBody(id:int,styleId:int):void
		{
			
			var url:String = createUrl('body',id,styleId,'body');
			loadPart(url,BODY_BONE);
			
			url = createUrl('body',id,styleId,'pelvis');
			loadPart(url,PELVIS_BONE);
		}
		
		public function updateArms(id:int,styleId:int):void
		{
			
			var url:String = createUrl('arm',id,styleId,'leftHand');
			loadPart(url,LEFT_HAND_BONE);
			
			url = createUrl('arm',id,styleId,'leftArm');
			loadPart(url,LEFT_ARM_BONE);
			
			url = createUrl('arm',id,styleId,'rightHand');
			loadPart(url,RIGHT_HAND_BONE);
			
			url = createUrl('arm',id,styleId,'rightArm');
			loadPart(url,RIGHT_ARM_BONE);
		}
		
		public function updateLegs(id:int,styleId:int):void
		{
			var url:String;
			url = createUrl('foot',id,styleId,'leftFoot');
			loadPart(url,LEFT_FOOT_BONE);
			url = createUrl('foot',id,styleId,'leftThigh');
			loadPart(url,LEFT_THIGH_BONE);
			
			url= createUrl('foot',id,styleId,'rightFoot');
			loadPart(url,RIGHT_FOOT_BONE);
			
			url = createUrl('foot',id,styleId,'rightThigh');
			loadPart(url,RIGHT_THIGH_BONE);
			
			url = createUrl('foot',id,styleId,'heel');
			loadPart(url,HEEL_BONE);
		}
		
		public function get isUpdated():Boolean
		{
			return loadingParts==0;
		}
		
	}
}