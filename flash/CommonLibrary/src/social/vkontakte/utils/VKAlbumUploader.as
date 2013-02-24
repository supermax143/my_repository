package social.vkontakte.utils
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	
	import social.vkontakte.loaders.MultipartURLLoader;
	import social.vkontakte.transport.VKApi;
	import social.vkontakte.transport.VKErrorResponce;
	import social.vkontakte.transport.VKResponce;
	

public class VKAlbumUploader extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	private var api:VKApi;
	private var serverUploadURL:String;

	
	private var userId:String;
	private var albumId:String;
	private var image:ByteArray;	
	private var data:Object = null;
	private var loader:MultipartURLLoader = new MultipartURLLoader(); 
	private var callback:Function;
	
	private var _inProcess:Boolean = false;
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    			
	public function VKAlbumUploader(serverUploadURL:String,api:VKApi)
	{
		this.api = api;
		this.serverUploadURL = serverUploadURL;

		loader.addEventListener(Event.COMPLETE, uploadCompleteHandler,false,0,true);	
		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler,false,0,true);	
		loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler,false,0,true);			
	}

	public function destroy():void
	{
		loader.removeEventListener(Event.COMPLETE, uploadCompleteHandler);	
		loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);	
		loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);	
		
		loader = null;
	}
    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------
	
	public function upload(image:ByteArray,userId:String,albumId:String,callback:Function = null):void
	{
		if(inProcess)
		{
			if(callback != null)
				callback(new Error("uploading already in proccess"));
			return;
		}
		this.userId = userId;
		this.albumId = albumId;
		this.image = image;
		this.callback = callback;
		
		loader.addFile(image,"photo.png","file1","image/png");
		loader.load(serverUploadURL);						
		_inProcess = true;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

	private function uploadCompleteHandler(event:Event):void
	{
		var result:String = String(event.currentTarget.loader.data);
		var data:Object = JSON.parse(result);

		api.savePhoto(data.aid, data.server, data.photos_list, data.hash,
			apiCompleteCallback,apiErrorHandler);
	}
	private function errorHandler(event:Event):void
	{
		_inProcess = false;	
		if(callback != null)
			callback(new Error(event.toString()));
		callback = null;
	}
	
	private function apiErrorHandler(responce:VKErrorResponce):void
	{
		_inProcess = false;	
		if(callback != null)
			callback(new Error(responce.errorMessage));
		callback = null;
	}	
	private function apiCompleteCallback(responce:VKResponce):void
	{
		_inProcess = false;	
		if(callback != null)
			callback();
		callback = null;	
	}
	
	public function get inProcess():Boolean
	{
		return _inProcess;
	}
}
}