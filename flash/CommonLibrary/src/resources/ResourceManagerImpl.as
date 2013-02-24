package resources {
import br.com.stimuli.loading.BulkLoader;
import br.com.stimuli.loading.BulkProgressEvent;
import br.com.stimuli.loading.loadingtypes.ImageItem;
import br.com.stimuli.loading.loadingtypes.LoadingItem;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.Sound;
import flash.media.SoundLoaderContext;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import graphics.Background;

import resources.events.LoadingItemEvent;



public class ResourceManagerImpl extends EventDispatcher implements IResourceManager{
    private var _loader:BulkLoader;
    private var _queuedBunches:Array;
    private var _isLoading:Boolean = false;
    private var _currentLoadingBunch:LoaderBunch;

    private var _appDomain:ApplicationDomain;
	private var _securityDomain:SecurityDomain;
    private var _loaderContext:LoaderContext;
	private var _soundLoaderContext:SoundLoaderContext;
    private var _bitmapDataCache:Dictionary;


    public function ResourceManagerImpl() {
        _queuedBunches = []
		_bitmapDataCache = new Dictionary(true);
        _appDomain = new ApplicationDomain(null);
		_securityDomain = SecurityDomain.currentDomain;
        _loaderContext = new LoaderContext(true, _appDomain,_securityDomain);
		_soundLoaderContext = new SoundLoaderContext(1000,true);
        _loader = new BulkLoader("main-loader");
        _loader.addEventListener(BulkLoader.COMPLETE, onBunchLoadedSuccessfully);
        _loader.addEventListener(BulkLoader.PROGRESS, onBunchLoadingProgress);
        _loader.addEventListener(BulkLoader.ERROR, onLoadingError);
    }

    public function loadBunch(resources:Array, progressHandler:Function, completeHandler:Function,errorHandler:Function=null):void {
        _queuedBunches.push(new LoaderBunch(resources, progressHandler, completeHandler,errorHandler));
        loadNext();
    }

	
    private function loadNext():void {
        if (_isLoading || _queuedBunches.length == 0)
            return;

        _currentLoadingBunch = _queuedBunches.shift();
        var queueSize:int = 0;
        for each(var res:BunchLoadingItem in _currentLoadingBunch.resources){
            if (_loader.get(res.url) != null)
                continue;
            ++queueSize;
			
			var itemType:String = BulkLoader.guessType(res.url);
				
            const props:Object = {context:itemType==BulkLoader.TYPE_SOUND?_soundLoaderContext:_loaderContext};
            if (res.shortId != null)
                props["id"] = res.shortId;
            
            if (res.isBinary){
                props["type"] = BulkLoader.TYPE_BINARY;
            }

            props[BulkLoader.PREVENT_CACHING] = res.preventCache;

            var item:LoadingItem = null;
            if (!res.isPost){
                item = _loader.add(res.url, props);
            }
            else{
                const postRequest:URLRequest = new URLRequest(res.url);
                postRequest.method = "POST";
                postRequest.data = res.postData;
                item = _loader.add(postRequest, props);
            }
			
        }
		
        if (queueSize > 0){
            _loader.start();
            _isLoading = true;
        }else{
            onBunchLoadedSuccessfully(null);
        }
    }

    

    private function onBunchLoadedSuccessfully(event:BulkProgressEvent):void {
        _currentLoadingBunch.completeHandler();
        _isLoading = false;
        _currentLoadingBunch = null;
        loadNext();
    }

    private function onBunchLoadingProgress(event:BulkProgressEvent):void {
        _currentLoadingBunch.progressHandler(event._ratioLoaded);
    }

    private function onLoadingError(event:ErrorEvent ):void {
        _isLoading = false;
		_currentLoadingBunch.errorHandler(event);
    }

    public function getBitmapData(name:String):BitmapData {
        if (_loader.hasItem(name))
            return _loader.getBitmapData(name);

        if (_bitmapDataCache.hasOwnProperty(name))
            return _bitmapDataCache[name];

        var result:BitmapData = null;

        const cl:Class = getClass(name);
        if (cl != null)
            result = new cl(1, 1) as BitmapData;

        if (result != null)
            _bitmapDataCache[name] = result;

        return result;
    }

    public function getBitmap(name:String) : Bitmap {
        var res: Bitmap;
        var bitmapData: BitmapData = getBitmapData(name);

        res = new Bitmap(bitmapData);

        return res;
    }

    public function getMovieClip(name : String) : MovieClip {
        var res: MovieClip;
        var classRef: Class = getClass(name);
        /*if(!classRef)
		{
			for each(var loadingItem:LoadingItem in _loader.items)
			{
				if(loadingItem.type != BulkLoader.TYPE_MOVIECLIP)
					continue;
				var mcResourseContainer:MovieClip = loadingItem.content as MovieClip;
				if(!mcResourseContainer)
					continue;
				classRef = mcResourseContainer.loaderInfo.applicationDomain.getDefinition(name) as Class
				if(classRef)
					break;
			}
		}*/
		if(classRef){
            var mc: MovieClip = new classRef();
            res = mc;
        }else{
            var movieClip : MovieClip = new MovieClip();
            movieClip.addChild(new Background(20,20,0xff00000,0,0.5));
            res = movieClip;
        }

        return res;
    }

    public function getSprite(name:String):Sprite {
        const cl:Class = getClass(name);
        if (cl != null)
            return new cl() as Sprite;

        return null;
    }

    public function getText(name:String, clearMemory:Boolean = false):String {
        return _loader.getText(name, clearMemory);
    }

    public function getClass(name:String) : Class
    {
        var cls:Class;
        try
        {			
            cls = _appDomain.getDefinition(name) as Class;
			
            if (cls != null)
            {
                return cls;
            }
        }
        catch (error:Error)
        {
            return null;
        }
        return null;
    }

    public function getBinary(name:String, clearMemory:Boolean):ByteArray {
        return _loader.getBinary(name,clearMemory);
    }
	
	public function getSound(name:String, clearMemory:Boolean):Sound {
		return _loader.getSound(name,clearMemory);
	}
	
	public function getLoadingItem(id:String):LoadingItem
	{
		return _loader.get(id);
	}
}


}

class LoaderBunch{
    private var _resources:Array;
    private var _progressHandler:Function;
    private var _completeHandler:Function;
	private var _errorHandler:Function;
	
    public function LoaderBunch(resources:Array, progressHandler:Function, completeHandler:Function,errorHandler:Function=null) {
        _resources = resources;
        _progressHandler = progressHandler;
        _completeHandler = completeHandler
		_errorHandler = errorHandler;
    }

	
    public function get resources():Array {
        return _resources;
    }

    public function get progressHandler():Function {
        return _progressHandler;
    }

    public function get completeHandler():Function {
        return _completeHandler;
    }

	public function get errorHandler():Function
	{
		return _errorHandler;
	}
	
	
	
}