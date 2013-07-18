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
				cameraShake -= .1;
				// Shake left right randomly.
				target.x = int(Math.random() * cameraShake - cameraShake * 0.5); 
				// Shake up down randomly.
				target.y = int(Math.random() * cameraShake - cameraShake * 0.5);
				TweenMax.delayedCall(.01,function():void{shake(target,cameraShake)})
			}
		}
		public function smoothScale(target:DisplayObject,time:Number,scaleValue:Number,compleateHandler:Function=null):void
		{
			TweenMax.to(target,time,{scaleX:scaleValue,scaleY:scaleValue
				,onComplete:function():void
				{
					if(compleateHandler!=null)
						compleateHandler();
				}});
		}
		
	}
}