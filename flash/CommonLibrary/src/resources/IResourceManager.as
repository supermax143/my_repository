
package resources {
import br.com.stimuli.loading.loadingtypes.LoadingItem;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.media.Sound;
import flash.utils.ByteArray;

public interface IResourceManager {
    function loadBunch(resources:Array, progressHandler:Function, completeHandler:Function,errorHandler:Function=null):void;

    function getBitmapData(name:String):BitmapData;

    function getBitmap(linkageName : String) : Bitmap;

    function getMovieClip(name : String) : MovieClip;

    function getText(name:String, clearMemory:Boolean = false):String;

    function getSprite(name:String):Sprite;

    function getBinary(name:String, clearMemory:Boolean):ByteArray;
	
	function getSound(name:String, clearMemory:Boolean):Sound
	
	function getLoadingItem(id:String):LoadingItem
	function addLoadingItem(id:String,props:Object=null):LoadingItem	
}
}
