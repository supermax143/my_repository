package social.vkontakte.utils
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.utils.ByteArray;

import mx.controls.Alert;

import social.vkontakte.loaders.MultipartData;
import social.vkontakte.loaders.MultipartURLLoader;
import social.vkontakte.transport.VKApi;
import social.vkontakte.transport.VKErrorResponce;
import social.vkontakte.transport.VKResponce;

import vk.APIConnection;

public class VKWallUploader extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	private var api:VKApi;
	private var apiConnector:APIConnection;
	private var serverUploadURL:String;
	
	
	private var userId:String;
	private var text:String;
	private var image:ByteArray;	
	private var data:Object = null;
	private var loader:URLLoader = new URLLoader(); 
	private var callback:Function;
	
	private var _inProcess:Boolean = false;
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function VKWallUploader(serverUploadURL:String,api:VKApi,apiConnector:APIConnection)
	{
		this.api = api;
		this.apiConnector = apiConnector;
		this.serverUploadURL = serverUploadURL;
		
	
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
	
	public function upload(image:ByteArray,userId:String,text:String,callback:Function = null):void
	{
		if(inProcess)
		{
			if(callback != null)
				callback(new Error("uploading already in proccess"));
			return;
		}
		this.userId = userId;
		this.text = text;
		this.image = image;
		this.callback = callback;
		
		var req:URLRequest = createPostURLRequest(serverUploadURL);
		var data:MultipartData = new MultipartData();
		data.addFile(image, "photo");
		req.data = data.data;
		
		loader.addEventListener(Event.COMPLETE, uploadCompleteHandler);	
		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);	
		loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);	
		
		loader.load(req);
		
						
		_inProcess = true;
	}
	
	private function createPostURLRequest(url:String):URLRequest {	
		var req:URLRequest = new URLRequest(url);
		req.method = URLRequestMethod.POST;
		req.requestHeaders.push(new URLRequestHeader("Content-Type", "multipart/form-data; boundary=" + MultipartData.BOUNDARY));
		return req;
	}
	
	
	//--------------------------------------------------------------------------
	//
	//  Event Handlers
	//
	//--------------------------------------------------------------------------
	
	private function uploadCompleteHandler(event:Event):void
	{
		var result:String = String(event.currentTarget.data);
		var data:Object = JSON.parse(result);
		data.format = 'xml'
		apiConnector.api('photos.saveWallPhoto', data,apiCompleteCallback,apiErrorHandler);		
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
		var result:XML = responce.xmlData;
		var photoId:String = result.photo.id;
		var params:Object = new Object();
		params.owner_id = userId;
		params.message = text;
		var attachment:String = photoId;
		
		params.attachment = attachment;
		apiConnector.api('wall.post',params);
	}
	
	public function get inProcess():Boolean
	{
		return _inProcess;
	}
}
}