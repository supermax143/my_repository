package graphics {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	public final class GraphixUtils {
		
		public static function createSpriteWrapper(object: DisplayObject) : Sprite {
			var res: Sprite = new Sprite();
			res.addChild(object);
			return res;
		}
		public static function wrapInSprite(object: DisplayObject) : Sprite {
			return createSpriteWrapper(object);
		}
		
		public static function removeAllChildren(container : DisplayObjectContainer, action : Function/*.<(displayObject : DisplayObject) : void>*/ = null) : void {
			if(container) {
				while(container.numChildren > 0) {
					var displayObject : DisplayObject = container.removeChildAt(0);
					if(action != null){
						action(displayObject);
					}
				}
			}
		}
		
		public function dispose() : void {
		}
		
		public static function delayedRemoveAll(container : DisplayObjectContainer) : void {
			var i : int;
			var forRemove : Array/*<Object>*/ = [];
			for(i=0; i<container.numChildren; i++){
				forRemove.push(container.getChildAt(i));
			}
			setTimeout(function () : void {
				for each(var dobj:DisplayObject in forRemove){
					if(container.contains(dobj)){
						container.removeChild(dobj);
					}
				}
			}, 1);
		}
		
		public static function addChildAll(collection : Object, container : DisplayObjectContainer) : void {
			for each(var obj:* in collection){
				if(obj is DisplayObject){
					container.addChild(obj);
				}else{
					addChildAll(obj, container);
				}
			}
		}
		
		public static function safeRemoveChild(child : DisplayObject) : void {
			if(child && child.parent) {
				child.parent.removeChild(child);
			}
		}
		
		public static function render(displayObject : DisplayObject, smoothing : Boolean = false) : BitmapData {
			var origParent : DisplayObjectContainer = displayObject.parent;
			var origX : Number = displayObject.x;
			var origY : Number = displayObject.y;
			
			var sp:Sprite = new Sprite();
			sp.addChild(displayObject);
			var bounds : Rectangle = sp.getBounds(sp);
//			trace("render: " + ["bounds: " + bounds]);
			displayObject.x -= bounds.x;
			displayObject.y -= bounds.y;
			
			var bitmapData : BitmapData = new BitmapData(bounds.width, bounds.height, true, 0);
			bitmapData.draw(sp, null, null, null, null, smoothing);
			
			displayObject.x = origX;
			displayObject.y = origY;
			if(origParent){
				origParent.addChild(displayObject);
			}
			
			return bitmapData;
		}
		
		public static function renderToBitmap(displayObject : DisplayObject, smoothing : Boolean = false) : Bitmap {
			return new Bitmap(render(displayObject, smoothing));
		}
		

		public static function toTop(obj : DisplayObject) : void {
			if(obj && obj.parent && obj.parent.contains(obj)){
				obj.parent.setChildIndex(obj, obj.parent.numChildren - 1);
			}
		}

		public static function rotateBitmapData(bitmapData : BitmapData, degree : Number) : BitmapData {
			var bitmap : Bitmap = new Bitmap(bitmapData);
			bitmap.rotation = degree;
			return render(bitmap);
		}
		
		public static function scaleBitmapData(bitmapData : BitmapData, scaleX : Number, scaleY : Number, disposeOriginal : Boolean = false) : BitmapData {
			if(isNaN(scaleX)){
				scaleX = scaleY;
			}
			
			if(isNaN(scaleY)){
				scaleY = scaleX;
			}
			
			var bitmap : Bitmap = new Bitmap(bitmapData);
			bitmap.scaleX = scaleX;
			bitmap.scaleY = scaleY;
			
			var res : BitmapData = render(bitmap);
			
			if(disposeOriginal){
				bitmapData.dispose();
			}
			
			return res;
		}
		
		public static function resizeBitmapData(bitmapData : BitmapData, width : int, height : int = 0, disposeOriginal : Boolean = false) : BitmapData {
			var bitmap : Bitmap = new Bitmap(bitmapData);
			if(width < 1 && height > 1){
				bitmap.height = height;
				bitmap.scaleX = bitmap.scaleY;
			}else
			if(height < 1 && width > 1){
				bitmap.width = width;
				bitmap.scaleY = bitmap.scaleX;
			}else{
				bitmap.width = width;
				bitmap.height = height;
			}
			
			var res : BitmapData = render(bitmap);
			
			if(disposeOriginal){
				bitmapData.dispose();
			}
			
			return res;
		}

		public static function addReflection(bitmapData : BitmapData, isVertical : Boolean, atStart : Boolean, length : Number = NaN, disposeOriginal : Boolean = true) : BitmapData {
			if(isNaN(length)){
				length = isVertical ? bitmapData.height : bitmapData.width;
			}
			
			var rect : Rectangle = bitmapData.rect.clone();
			if(isVertical){
				rect.height += length;
			}else{
				rect.width += length;
			}
			
			var res : BitmapData = new BitmapData(rect.width, rect.height, bitmapData.transparent, 0);
			
			var mirrored : BitmapData;
			if(isVertical){
				mirrored = new BitmapData(bitmapData.width, length, bitmapData.transparent, 0);
			}else{
				mirrored = new BitmapData(length, bitmapData.height, bitmapData.transparent, 0);
			}
			
			var mirrorRect : Rectangle = bitmapData.rect.clone();
			if(isVertical){
				mirrorRect.height = length;
				if(!atStart){
					mirrorRect.y = bitmapData.height - length;
				}
			}else{
				mirrorRect.width = length;
				if(!atStart){
					mirrorRect.x = bitmapData.width - length;
				}
			}
			mirrored.copyPixels(bitmapData, mirrorRect, new Point());
			if(isVertical){
				mirrored = scaleBitmapData(mirrored, 1, -1, true); 
			}else{
				mirrored = scaleBitmapData(mirrored, -1, 1, true); 
			}
			
			if(isVertical){
				if(atStart){
					res.copyPixels(mirrored, mirrored.rect, new Point()); 
					res.copyPixels(bitmapData, bitmapData.rect, new Point(0, length));
				}else{
					res.copyPixels(bitmapData, bitmapData.rect, new Point(0, 0));
					res.copyPixels(mirrored, mirrored.rect, new Point(0, bitmapData.height)); 
				}
			}else{
				if(atStart){
					res.copyPixels(mirrored, mirrored.rect, new Point()); 
					res.copyPixels(bitmapData, bitmapData.rect, new Point(length, 0));
				}else{
					res.copyPixels(bitmapData, bitmapData.rect, new Point(0, 0));
					res.copyPixels(mirrored, mirrored.rect, new Point(bitmapData.width, 0)); 
				}
			}
			
			mirrored.dispose();
			
			if(disposeOriginal){
				bitmapData.dispose();
			}
			
			return res;
		}
		
		public static function addReflectionSequence(bitmapData : BitmapData, isVertical : Boolean, atStart : Boolean, length : Number = NaN, disposeOriginal : Boolean = true, minLimit : int = 10, multiplier : Number = 0.5) : BitmapData {
			if(isNaN(length)){
				length = isVertical ? bitmapData.height : bitmapData.width;
			}
			
			var res : BitmapData = bitmapData.clone();
			
			var lastL : Number = length * multiplier;
			
			var f : Function = function () : void {
				res = addReflection(res, isVertical, atStart, lastL, true);
				lastL = Math.max(minLimit, lastL * multiplier);
			} 
			
			if(isVertical){
				while(res.height < bitmapData.height + length){
					f();
				}
			}else{
				while(res.width < bitmapData.width + length){
					f();
				}
			}
			
			if(disposeOriginal){
				bitmapData.dispose();
			}
			
			return res;
		}
		
		public static function convertToBitmap(target:DisplayObject,saveRegisterPoint:Boolean=true):DisplayObject
		{
			var rect:Rectangle = target.getRect(target);
			var mat:Matrix=new Matrix();
			var translateX:Number = -rect.x;
			var translateY:Number = -rect.y;
			mat.translate(translateX,translateY);
			var bitmapData:BitmapData = new BitmapData(target.width,target.height,true,0x000000);
			bitmapData.draw(target,mat);
			var bitMap:Bitmap = new Bitmap(bitmapData);
			bitMap.smoothing = true;
			if(saveRegisterPoint)
			{
				bitMap.x = rect.x;
				bitMap.y = rect.y;
			}
			return bitMap;
		}
		
		public static function createHitArea(bitmapData:BitmapData, grainSize:uint=1):Sprite {
			var _hitarea:Sprite = new Sprite();
			_hitarea.graphics.beginFill(0x000000, 1.0);			
			for(var x:uint=0;x<bitmapData.width;x+=grainSize) {
				for(var y:uint=grainSize;y<bitmapData.height;y+=grainSize) {					
					if(x<=bitmapData.width && y<=bitmapData.height && bitmapData.getPixel(x,y)!=0) {
						_hitarea.graphics.drawRect(x,y,grainSize,grainSize);						
					}					
				}
			}			
			_hitarea.graphics.endFill();						
			return _hitarea;
		}
	}
}
