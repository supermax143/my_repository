package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

    public class EmbeddedAssets
    {
      
        
        // Dragon Bones assets
        
		[Embed(source = "../assets/robot_resource_mobile_output.swf", mimeType = "application/octet-stream")]
		public static const Robot_output:Class;
       
		/**
		 * Background Assets 
		 */
		[Embed(source="../assets/Arena1.jpg")]
		public static const Arena1:Class;
		
		
		/**
		 * Texture Cache 
		 */
		private static var gameTextures:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new EmbeddedAssets[name]();
				gameTextures[name]=Texture.fromBitmap(bitmap);
			}
			
			return gameTextures[name];
		}
		
    }
}