package social.myworld.transport
{


import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.Dictionary;



import social.myworld.data.MWApplicationData;
import social.utils.MD5;

[Bindable]
public class MWApi
{

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------
	
    public var testMode:Boolean = false;

    private var _apiServerURL:String = "http://www.appsmail.ru/platform/api";
    private var _format:String = "xml";
    private var _applicationSettings:MWApplicationData;
    
    private var requestsDictionary:Dictionary;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //-------------------------------------------------------------------------

    public function MWApi()
    {
		requestsDictionary = new Dictionary(true);
    }


	//--------------------------------------------------------------------------
	//
	//  Wrapper Methods
	//
	//-------------------------------------------------------------------------	
		
	public function friendsInvite():void
	{
		execute("mailru.app.friends.invite");
	}
	public function requireInstallation(permissions:Array):void
	{
		execute("mailru.app.users.requireInstallation",null,permissions);
	}
	public function execute(method:String,callback:Function = null,... params):void
	{
		var callFunction:Function =  MailruCall.exec;
		params.unshift(method,callback);
		callFunction.apply(null,params);
		//MailruCall.exec(method,callback,params);
	}
		
	//--------------------------------------------------------------------------
	//
	//  API Methods
	//
	//-------------------------------------------------------------------------		
	public function getInfo(uids:String,resultHandler:Function = null,faultHandler:Function = null):void
	{
        var params:Dictionary = new Dictionary(false);
        params.method = "users.getInfo";
        params.uids = uids;
        params.session_key = applicationSettings.sessionKey;
        if(testMode)
        	params.debug = "1";
        sendRequest(params,resultHandler,faultHandler);		
	}
	public function openPayment(serviceID:String,serviceName:String,otherPrice:Number = NaN,smsPrice:Number = NaN,resultHandler:Function = null,faultHandler:Function = null):void
	{
        var params:Dictionary = new Dictionary(false);
        params.method = "payments.openDialog";
        params.service_id  = serviceID;        
        params.service_name  = serviceName;
        params.session_key = applicationSettings.sessionKey;
                
        if(!isNaN(smsPrice))      
      		params.sms_price = smsPrice;   
      		
        if(!isNaN(otherPrice))    
        	params.other_price = otherPrice;    
        	    

        params.window_id = applicationSettings.windowID;
        sendRequest(params,resultHandler,faultHandler);		
	}
	public function getFriends(resultHandler:Function = null,faultHandler:Function = null):void
	{
        var params:Dictionary = new Dictionary(false);
        params.method = "friends.get";
        params.session_key = applicationSettings.sessionKey;
        params.ext = "1";
        sendRequest(params,resultHandler,faultHandler);		
	}
	public function getAppFriends(resultHandler:Function = null,faultHandler:Function = null):void
	{
        var params:Dictionary = new Dictionary(false);
        params.method = "friends.getAppUsers";
        params.session_key = applicationSettings.sessionKey;
        params.ext = "1";
        sendRequest(params,resultHandler,faultHandler);		
	}
	public function publish(text:String,plainText:String = null,img:Number = NaN,resultHandler:Function = null,faultHandler:Function = null):void
	{
        var params:Dictionary = new Dictionary(false);
        params.method = "stream.publish";
        params.session_key = applicationSettings.sessionKey;
        params.text = text;
        
        if(plainText != null)
        	params.post = plainText;
        if(!isNaN(img))
        	params.img = img;
        sendRequest(params,resultHandler,faultHandler);		
	}


	//--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //-------------------------------------------------------------------------

    private function createRequest(requestVariables:URLVariables):URLRequest
    {
        var request:URLRequest = new URLRequest();
        request.url = apiServerURL;
        request.method = URLRequestMethod.POST;
        request.data = requestVariables;
        return request;
    }
    private function createRequestParams(addParameters:Dictionary = null):Dictionary
    {
        var request:Dictionary = new Dictionary(true);

        if(addParameters)
            for (var key:String in addParameters)
                request[key] = addParameters[key];
        
        request.format = format;
        request.app_id = applicationSettings.applicationID;
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

        signature = applicationSettings.viewerID + signature + applicationSettings.privateKey;
        return MD5.encrypt(signature);
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
        requestsDictionary[info.loader] = info;
        info.sendRequest();
    }
 
	//--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
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
			requestInfo.errorHandler.call(null,new MWErrorResponce(data));
			return;
		}
		var localName:String = data.name().localName;
		
		if(localName == "error")
			requestInfo.errorHandler.call(null,new MWErrorResponce(data));
		else
			requestInfo.resultHandler.call(null,new MWResponce(data));
    }
    private function loaderFaultHandler(event:Event):void
    {
		var loader:URLLoader = event.target as URLLoader;
		var requestInfo:RequestInfo = requestsDictionary[loader] as RequestInfo;
		if(!requestInfo)
			return;
		
		var error:MWErrorResponce = new MWErrorResponce(null);
		error.errorMessage = "Fault to request "+loader.toString(); 
		requestInfo.errorHandler.call(null,error);
    }
    private function requestInfoDefaultResultHandler(responce:MWResponce):void
    {

    }
    private function requestInfoDefaultErrorHandler(responce:MWErrorResponce):void
    {
		if(responce && responce.xmlData)
			trace("Request error: "+responce.xmlData["error_msg"]);    	
    }
	//--------------------------------------------------------------------------
    //
    //  Public Properties
    //
    //-------------------------------------------------------------------------

    public function get format():String
    {
        return _format;
    }

    public function set format(value:String):void
    {
        _format = value;
    }
    public function get apiServerURL():String
    {
        return _apiServerURL;
    }

    public function set apiServerURL(value:String):void
    {
        _apiServerURL = value;
    }

    public function get applicationSettings():MWApplicationData
    {
        return _applicationSettings;
    }

    public function set applicationSettings(value:MWApplicationData):void
    {
        _applicationSettings = value;
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