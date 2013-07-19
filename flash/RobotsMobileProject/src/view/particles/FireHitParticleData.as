package view.particles
{
	import com.greensock.TweenMax;
	
	import dragonBones.Bone;
	
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	import view.dollview.DollBase;
	import view.dollview.RobotDoll;
	import view.dollview.RobotDollPartsManager;
	
	public class FireHitParticleData extends ParticleData
	{
		
		private var time:Number = .2;
		
		public function FireHitParticleData(target:DollBase, animationId:String)
		{
			super(target, animationId);
			create();
		}
		
		private function create():void
		{
			var particle:PDParticleSystem = new PDParticleSystem(XML(new ParticleAssets.HitParticleXML()), Texture.fromBitmap(new ParticleAssets.CircleParticleTexture()));
			var bone:Bone  
			
			if(Math.random()>.5)
			{
				bone = target.getBone(RobotDollPartsManager.BODY_BONE);
			}
			else
			{
				bone = target.getBone(RobotDollPartsManager.HEAD_BONE);
			}
			
			var deltaX:Number = Math.random()*7*(Math.random()>.5?1:-1);
			var deltaY:Number = Math.random()*7*(Math.random()>.5?1:-1);
			Starling.juggler.add(particle);
			particle.emitterX = (target.x+getCenterX(bone)*target.scaleX)+deltaX;
			particle.emitterY = (target.y+getCenterY(bone))+deltaY;
			particle.maxNumParticles = 30;
			particle.speedVariance = 100;
			particle.emitAngle = target.scaleX>0?180:0;
			particle.start(time);
			frontParticles.push(particle);
			TweenMax.delayedCall(time,function():void{remove()})
			
		}
	}
}