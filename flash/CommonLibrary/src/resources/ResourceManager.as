
package resources {
import br.com.stimuli.loading.loadingtypes.LoadingItem;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.media.Sound;
import flash.utils.ByteArray;

public class ResourceManager implements IResourceManager{
    private static var _me:IResourceManager;
    
    public function ResourceManager() {
    }

    public static function get instance():IResourceManager {
        if (_me == null){
            _me = new ResourceManager();
        }
        
        return _me;
    }

    public static function set instance(value:IResourceManager):void {
        _me = value;
    }

    public function loadBunch(resources:Array, progressHandler:Function, completeHandler:Function,errorHandler:Function=null):void {
        throw new Error("ResourceManager::loadBunch() not implemented!");
    }


    public function getBitmapData(name:String):BitmapData {
        throw new Error("ResourceManager::getBitmapData() not implemented!");
        return null;
    }

    public function getBitmap(linkageName:String):Bitmap {
        throw new Error("ResourceManager::getBitmap() not implemented!");
        return null;
    }

    public function getMovieClip(name:String):MovieClip {
        throw new Error("ResourceManager::getMovieClip() not implemented!");
        return null;
    }

    public function getText(name:String, clearMemory:Boolean = false):String {
        throw new Error("ResourceManager::getText() not implemented!");
        return "";
    }

    public function getSprite(name:String):Sprite {
        throw new Error("ResourceManager::getSprite() not implemented!");
        return null;
    }

    public function getBinary(name:String, clearMemory:Boolean):ByteArray {
        throw new Error("ResourceManager::getBinary() not implemented!");
        return null;
    }
	
	public function getSound(name:String, clearMemory:Boolean):Sound {
		throw new Error("ResourceManager::getSound() not implemented!");
		return null;
	}
	
	public function getLoadingItem(id:String):LoadingItem {
		throw new Error("ResourceManager::getLoadingItem() not implemented!");
		return null;
	}
	
}
}
