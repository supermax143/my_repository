package social.vkontakte.transport
{

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.Dictionary;
import flash.utils.Timer;

import social.utils.MD5;
import social.vkontakte.data.*;

[Bindable]
public class VKTransport
{


    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //-------------------------------------------------------------------------
    
	private static const MAX_REQUESTS_PER_SECOND:uint = 3;
	
	public static const FULL_USER_INFO:String = "uid,first_name,last_name,nickname,sex," +
			"bdate,city,country,timezone,photo,photo_medium,photo_big,has_mobile,rate";

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------
    private var _testMode:Boolean = false;

    private var _apiVersion:String = "2.0";
    private var _applicationSettings:VKApplicationData;
    
	public var requestMethod:String = URLRequestMethod.POST;
	
	
    private var requests:Array;
    private var requestsDictionary:Dictionary;
    private var requestsTimer:Timer;
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //-------------------------------------------------------------------------

    public function VKTransport()
    {
		requests = new Array();
		requestsDictionary = new Dictionary(true);
		requestsTimer = new Timer(1000);
		requestsTimer.addEventListener(TimerEvent.TIMER,requestTimerCompleteHandler,
			false,0,true);
    }
  
	//--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //-------------------------------------------------------------------------

	public function getAppFriends(resultHandler:Function = null,faultHandler:Function = null):void
	{
        var params:Dictionary = new Dictionary(false);
        params.method = "getAppFriends";
        sendRequest(params,resultHandler,faultHandler);			
	}
	public function getFriends(resultHandler:Function = null,faultHandler:Function = null):void
	{
		
		var params:Dictionary = new Dictionary(false);
        params.method = "getFriends";
        sendRequest(params,resultHandler,faultHandler);		
	}

    public function getCities(cids:String,resultHandler:Function = null,
    	faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "getCities";
        params.cids = cids;
        sendRequest(params,resultHandler,faultHandler);
    }
    public function getCountries(cids:String,resultHandler:Function = null,
    	faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "getCountries";
        params.cids = cids;
        sendRequest(params,resultHandler,faultHandler);
    }
    public function getProfiles(uids:String,fields:String,resultHandler:Function = null,
    	faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "getProfiles";
        params.uids = uids;
        params.fields = fields;
        sendRequest(params,resultHandler,faultHandler);
    }
    
    public function saveWallPost(userID:String, postID:String = null,
    	server:String = null, photo:String = null, hash:String = null,
    	photoID:String = null, message:String = null,
    	resultHandler:Function = null, faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "wall.savePost";
        params.wall_id = userID;
        if(postID != null)
        	params.post_id = postID;
        if(server != null)
        	params.server = server;
        if(photo != null)
        	params.photo = photo;
        if(hash != null)
        	params.hash = hash;
        if(photoID != null)
        	params.photoID = photoID;
        if(message != null)
        	params.message = message;
        sendRequest(params,resultHandler,faultHandler);    	
    }
    public function getWallPhotoUploadServer(resultHandler:Function = null,
    	faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "wall.getPhotoUploadServer";
        sendRequest(params,resultHandler,faultHandler);
    }
    public function getPhotosUploadServer(aid:String,saveBig:int = 0,resultHandler:Function = null,
    	faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "photos.getUploadServer";
        params.aid = aid;
        params.save_big = saveBig;
        sendRequest(params,resultHandler,faultHandler);
    }
    public function getFullProfiles(uids:String,resultHandler:Function = null,
    	faultHandler:Function = null):void
    {
        getProfiles(uids,FULL_USER_INFO,resultHandler,faultHandler);
    }
    
    public function getPhotoAlbums(uid:String,resultHandler:Function = null,
    	faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "photos.getAlbums";
        params.uid = uid;
        sendRequest(params,resultHandler,faultHandler);
    }

    public function getUserBalance(resultHandler:Function,faultHandler:Function = null,uids:String = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "getUserBalance";
		if(uids)
			params.uids = uids;
        sendRequest(params,resultHandler,faultHandler);
    }
    
    public function isAppUser(uid:String,resultHandler:Function,faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "isAppUser";
        params.uid = uid;
        sendRequest(params,resultHandler,faultHandler);
    }
    public function getAds(count:uint,type:int,minPrice:Number,resultHandler:Function,faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "getAds";
        params.count = count;
        params.type = type;
        params.min_price = minPrice;
        sendRequest(params,resultHandler,faultHandler);
    }
    public function createPhotoAlbum(title:String,description:String,privacy:int = 0,commentPrivacy:int = 0,resultHandler:Function = null,faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "photos.createAlbum";     
        params.title = title;     
        params.description = description;     
        params.privacy = privacy;     
        params.commentPrivacy = commentPrivacy;     
        sendRequest(params,resultHandler,faultHandler);
    }
    public function savePhoto(aid:String,server:String,photosList:String,hash:String,resultHandler:Function = null,faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "photos.save";     
        params.aid = aid;  
        params.server = server;  
        params.photos_list = photosList;  
        params.hash = hash;  
  
        sendRequest(params,resultHandler,faultHandler);
    }
    
	//--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //-------------------------------------------------------------------------

    protected function createRequest(requestVariables:URLVariables):URLRequest
    {
        var request:URLRequest = new URLRequest();
        request.url = applicationSettings.apiURL;
        request.method = requestMethod;
        request.data = requestVariables;
        return request;
    }
    private function createRequestParams(addParameters:Dictionary = null):Dictionary
    {
        var request:Dictionary = new Dictionary(true);

       if(testMode)
            request.test_mode = "1";

        request.v = apiVersion;
        
        if(addParameters)
            for (var key:String in addParameters)
                request[key] = addParameters[key];

        request.api_id = applicationSettings.applicationId;
        request.sig = createSignature(request);
        return request;
    }    
    private function createSignature(request:Dictionary):String
    {
        if(!applicationSettings)
            throw new Error("You must set applicationSettings before create signature");

        var signature:String = new String();
        var sortedArray: Array = new Array();

        for (var key:String in request)
            sortedArray.push(key + "=" + request[key]);

        sortedArray.sort();

        for (key in sortedArray)
            signature += sortedArray[key];

        signature = buildSignature(signature);
        return MD5.encrypt(signature);
    }
	
	protected function buildSignature(signature:String):String
	{
		return applicationSettings.viewerId + signature + applicationSettings.applicationSecretKey;
	}
	
     private function sendRequest(params:Dictionary,resultHandler:Function = null,
    	errorHandler:Function = null):void
    {
        var requestParams:Dictionary = createRequestParams(params);
        var variables:URLVariables = new URLVariables();

        for (var key:String in requestParams)
            variables[key] = requestParams[key];

        var request:URLRequest = createRequest(variables);
        var loader:URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.TEXT;
		
		if(resultHandler == null)
			resultHandler = requestInfoDefaultResultHandler;
		
		if(errorHandler == null)
			errorHandler = requestInfoDefaultErrorHandler;
			
        loader.addEventListener(Event.COMPLETE,loaderResultHandler,false,0,true);
        loader.addEventListener(IOErrorEvent.IO_ERROR,loaderFaultHandler,false,0,true);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,loaderFaultHandler,false,0,true);
       
        var info:RequestInfo = new RequestInfo(loader,request,resultHandler,errorHandler);
        requestsDictionary[loader] = info;
        requests.push(info);
        
        if(!requestsTimer.running)
       		requestsTimer.start();
    }
 
	//--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    private function requestTimerCompleteHandler(event:TimerEvent = null):void
    {
    	if(requests.length == 0)
    	{
    		requestsTimer.stop();
    		return;
    	}

    	var endIndex:int = Math.min(MAX_REQUESTS_PER_SECOND,requests.length - 1);
 		var requestsToSend:Array = requests.splice(0,2);
    	for each(var request:RequestInfo in requestsToSend)
			request.sendRequest();	
    }
    private function loaderResultHandler(event:Event):void
    {
		var loader:URLLoader = event.target as URLLoader;
		var requestInfo:RequestInfo = requestsDictionary[loader] as RequestInfo;
		if(!requestInfo)
			return;
		
		try
		{	
			var data:XML = new XML(loader.data);
		}
		catch(error:Error)
		{
			requestInfo.errorHandler.call(null,new VKErrorResponce(data));
			return;
		}
		var localName:String = data.name().localName;
		
		if(localName == "error")
			requestInfo.errorHandler.call(null,new VKErrorResponce(data));
		else
			requestInfo.resultHandler.call(null,new VKResponce(data));
    }
    private function loaderFaultHandler(event:Event):void
    {
		var loader:URLLoader = event.target as URLLoader;
		var requestInfo:RequestInfo = requestsDictionary[loader] as RequestInfo;
		if(!requestInfo)
			return;
		
		var error:VKErrorResponce = new VKErrorResponce(null);
		error.errorMessage = "Fault to request "+loader.toString(); 
		requestInfo.errorHandler.call(null,error);
    }
    private function requestInfoDefaultResultHandler(responce:VKResponce):void
    {

    }
    private function requestInfoDefaultErrorHandler(responce:VKErrorResponce):void
    {
		if(responce && responce.xmlData)
			trace("Request error: "+responce.xmlData["error_msg"]);    	
    }
	//--------------------------------------------------------------------------
    //
    //  Public Properties
    //
    //-------------------------------------------------------------------------

    public function set apiVersion(value:String):void
    {
        _apiVersion = value;
    }

    public function get apiVersion():String
    {
        return _apiVersion;
    }


    public function get applicationSettings():VKApplicationData
    {
        return _applicationSettings;
    }

    public function set applicationSettings(value:VKApplicationData):void
    {
        _applicationSettings = value;
    }

    public function get testMode():Boolean
    {
        return _testMode;
    }

    public function set testMode(value:Boolean):void
    {
        _testMode = value;
    }
}
}

import flash.net.URLLoader;
import flash.net.URLRequest;
class RequestInfo
{
	public var loader:URLLoader;	
	public var request:URLRequest;	
	public var resultHandler:Function;	
	public var errorHandler:Function;	
	
	public function RequestInfo(loader:URLLoader,request:URLRequest,
		resultHandler:Function,errorHandler:Function)
	{
		this.loader = loader;	
		this.request = request;	
		this.resultHandler = resultHandler;	
		this.errorHandler = errorHandler;	
	}
	public function sendRequest():void
	{
		loader.load(request);
	}
}