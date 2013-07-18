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
	
	public class HitParticleData extends ParticleData
	{
		
		private var time:Number = .2;
		
		public function HitParticleData(target:DollBase, animationId:String)
		{
			super(target, animationId);
			create();
		}
		
		private function create():void
		{
			var particle:PDParticleSystem = new PDParticleSystem(XML(new ParticleAssets.ParticleCoffeeXML()), Texture.fromBitmap(new ParticleAssets.CircleParticleTexture()));
			var bone:Bone  
				
			switch(animationId)
			{
				
				case RobotDoll.KICK_ANIMATION:
					bone = target.getBone(RobotDollPartsManager.BODY_BONE);
					break;
				default:
					bone = target.getBone(RobotDollPartsManager.HEAD_BONE);
					break;
				
			}
			
			Starling.juggler.add(particle);
			particle.emitterX = target.x+getCenterX(bone)*target.scaleX;
			particle.emitterY = target.y+getCenterY(bone);
			particle.maxNumParticles = 200;
			particle.emitAngle = target.scaleX>0?180:0;
			particle.start(time);
			frontParticles.push(particle);
			TweenMax.delayedCall(time,function():void{remove()})
			
		}
	}
}