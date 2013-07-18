package view.particles
{
	import com.greensock.TweenMax;
	
	import dragonBones.Bone;
	
	import flash.display.DisplayObject;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Juggler;
	import starling.events.EventDispatcher;
	import starling.extensions.PDParticleSystem;
	
	import view.dollview.DollBase;

	public class ParticleData
	{
		
		public static const HIT_PARTICLE:String = "hit";
		
		
		protected var target:DollBase;
		protected var animationId:String;
		
		public var frontParticles:Array = [];
		
		public var removeSignal:Signal;
		
		
		public function ParticleData(target:DollBase,animationId:String)
		{
			this.target = target;
			this.animationId = animationId;
			removeSignal = new Signal(ParticleData);
		}
		
		public static function init(target:DollBase,particle:String,animationId:String):ParticleData
		{
			var pData:ParticleData;
			switch(particle)
			{
				case HIT_PARTICLE:
					pData = new HitParticleData(target,animationId)
					break;
				
			}
			return pData;
		}
		
		private function checkAllParticlesRemoved():void
		{
			for each(var particle:PDParticleSystem in frontParticles)
			{
				if(particle.numParticles>0)
				{
					remove();
					return;
				}
			}
			
			removeSignal.dispatch(this);
			
		}
		
		protected function remove():void
		{
			TweenMax.delayedCall(.5,function():void{checkAllParticlesRemoved()});
		}
		
		
		
		public function getRealX(bone:Bone):Number
		{
			return bone.origin.x - bone.origin.pivotX;
		}
		
		
		public function getRealY(bone:Bone):Number
		{
			return bone.origin.y - bone.origin.pivotY;
		}
		
		public function getCenterX(bone:Bone):Number
		{
			return getRealX(bone) + bone.display.width/2;
		}
		
		
		public function getCenterY(bone:Bone):Number
		{
			return getRealY(bone) + bone.display.height/2;
		}
		
	}
}