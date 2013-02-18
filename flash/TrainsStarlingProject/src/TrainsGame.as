package
{
	import com.emibap.textureAtlas.DynamicAtlas;
	
	import resources.ResourceManager;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;

	public class TrainsGame extends Sprite
	{
		public function TrainsGame()
		{
			var atlas:TextureAtlas = 
				DynamicAtlas.fromMovieClipContainer(ResourceManager.instance.getMovieClip('locomotives_container'), .4, 0, true, true);
			for (var i:int = 0; i < 50; i++) 
			{
				var textureName:String = Math.random()>.5?'locomotive_type1':'locomotive_type3';
				var boy_mc:MovieClip = new MovieClip(atlas.getTextures(textureName), 30);
				boy_mc.fps = 60;
				boy_mc.x = Math.random()*700;
				boy_mc.y = Math.random()*700;
				addChild(boy_mc);
				Starling.juggler.add(boy_mc);
			}
			
		}
	}
}