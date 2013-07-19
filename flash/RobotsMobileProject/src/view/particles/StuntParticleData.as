package view.particles
{
	import com.greensock.TweenMax;
	
	import dragonBones.Bone;
	
	import starling.core.Starling;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	import view.dollview.DollBase;
	import view.dollview.RobotDollPartsManager;
	
	public class StuntParticleData extends ParticleData
	{
		
		private var time:Number = 3;
		
		public function StuntParticleData(target:DollBase, animationId:String)
		{
			super(target, animationId);
			create();
		}
		
		private function create():void
		{
			var smokeParticle:PDParticleSystem = new PDParticleSystem(XML(new ParticleAssets.SmokeParticleXML()), Texture.fromBitmap(new ParticleAssets.CircleParticleTexture()));
			var bone:Bone = target.getBone(RobotDollPartsManager.HEAD_BONE); 
			
			
			Starling.juggler.add(smokeParticle);
			smokeParticle.emitterX = target.x+getCenterX(bone)*target.scaleX;
			smokeParticle.emitterY = target.y+getCenterY(bone);
			smokeParticle.maxNumParticles = 200;
		
			smokeParticle.start(time);
			frontParticles.push(smokeParticle);
			TweenMax.delayedCall(time,function():void{remove()})
			
		}
	}
}