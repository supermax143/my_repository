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

import vk.APIConnection;

[Bindable]
public class VKApi
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

    private var _applicationSettings:VKApplicationData;
	private var apiConnection:APIConnection;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function VKApi(apiConnect:APIConnection)
    {
		apiConnection = apiConnect;
    }
  
	//--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //-------------------------------------------------------------------------

	public function getAppFriends(resultHandler:Function = null,faultHandler:Function = null):void
	{
		var params:Object = new Object();
        sendApiRequest("getAppFriends",params,resultHandler,faultHandler);			
	}
	public function getFriends(resultHandler:Function = null,faultHandler:Function = null):void
	{
        var params:Object = new Object();
        sendApiRequest("friends.get",params,resultHandler,faultHandler);		
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
        var params:Object = new Object();
		var userId:String = _applicationSettings.userId;
		if(userId)
			userId = _applicationSettings.viewerId;
        params.uids = uids?uids:userId;
        params.fields = fields;
       sendApiRequest("users.get",params,resultHandler,faultHandler);
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
		sendApiRequest('photos.saveWallPhoto',params,resultHandler,faultHandler);    	
    }
    public function getWallPhotoUploadServer(whomUploadId:String,resultHandler:Function = null,faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
		params.uid = whomUploadId;
        sendApiRequest("photos.getWallUploadServer",params,resultHandler,faultHandler);
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

    public function getUserBalance(resultHandler:Function,faultHandler:Function = null):void
    {
        var params:Dictionary = new Dictionary(false);
        params.method = "getUserBalance";
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
	public function isGroupMember(groupId:String, userId:String, resultHandler:Function = null, faultHandler:Function = null):void {
		var params:Dictionary = new Dictionary(false);
		params.gid = groupId;  
		params.uid = userId;
		
		sendApiRequest("groups.isMember", params, resultHandler, faultHandler);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //-------------------------------------------------------------------------

	private function sendRequest(params:Object,handler:Function,faltHandler:Function):void
	{
		trace("Method not inited")
	}
	
	private function sendApiRequest(method:String,params:Object,resultHandler:Function=null,faultHandler:Function=null):void
	{
		if(testMode)
			params.test_mode = 1;
		params.format = 'xml'
		if(faultHandler==null)	
			faultHandler = defoltHandler;
		apiConnection.api(method,params,resultHandler,faultHandler);
	}
   
	private function defoltHandler(request:VKResponce):void
	{
		trace(request.xmlData);
	}
	
 	//--------------------------------------------------------------------------
    //
    //  Public Properties
    //
    //-------------------------------------------------------------------------


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
