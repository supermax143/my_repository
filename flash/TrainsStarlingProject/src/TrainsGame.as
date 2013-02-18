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
				DynamicAtlas.fromMovieClipContainer(ResourceManager.instance.getMovieClip('locomotive_type4'), 1, 0, true, true);
			trace(atlas)
			var boy_mc:MovieClip = new MovieClip(atlas.getTextures(), 10);
			boy_mc.x = 100;
			boy_mc.y = 50;
			addChild(boy_mc);
			Starling.juggler.add(boy_mc);
		}
	}
}