package utils
{
	import com.greensock.TweenMax;
	
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;

	public class CameraManager
	{
		//--------------------------------------------------------------------------
		//
		//  Static properties
		//
		//--------------------------------------------------------------------------
		private static var  _instance:CameraManager;
		public static function get instance():CameraManager
		{
			if (!_instance){
				_instance = new CameraManager();
			}
			
			return _instance;
		}
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public var completeSignal:Signal;
		
		public function CameraManager()
		{
			completeSignal = new Signal();
		}
		
		public function shake(target:DisplayObject,cameraShake:Number):void
		{
			if(cameraShake<=0)
			{
				target.x = 0;
				target.y = 0;
			}
			else
			{
				cameraShake -= .03;
				// Shake left right randomly.
				target.x = int(Math.random() * cameraShake - cameraShake  * (Math.random()>.5?1:-1)); 
				// Shake up down randomly.
				target.y = int(Math.random() * cameraShake - cameraShake  * (Math.random()>.5?1:-1));
				TweenMax.delayedCall(.03,function():void{shake(target,cameraShake)})
			}
		}
		public function smoothScale(target:DisplayObject,time:Number,scaleValue:Number,moveLeft:Boolean=false,compleateHandler:Function=null):void
		{
			var deltaX:Number = moveLeft?target.width - target.width*scaleValue:0;
			var deltaY:Number = target.height - target.height*scaleValue;
			TweenMax.to(target,time,{scaleX:scaleValue,scaleY:scaleValue,y:deltaY,x:deltaX,
				onComplete:function():void
				{
					if(compleateHandler!=null)
						compleateHandler();
				}});
		}
		
	}
}