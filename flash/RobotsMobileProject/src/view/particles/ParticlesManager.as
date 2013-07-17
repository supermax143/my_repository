package view.particles
{
	import org.osflash.signals.Signal;
	
	import view.dollview.DollBase;

	public class ParticlesManager
	{
		
		public var addParticleSignal:Signal;
		public var removeParticleSignal:Signal;
		
		public function ParticlesManager()
		{
			addParticleSignal = new Signal(ParticleData);
			removeParticleSignal = new Signal(ParticleData);
		}
		
		public function showParticle(target:DollBase,particleData:String):void
		{
			
		}
		
	}
}