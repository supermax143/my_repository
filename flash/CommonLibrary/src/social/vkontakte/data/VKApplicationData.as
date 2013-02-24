package social.vkontakte.data
{
import social.utils.MD5;

[Bindable]
public class VKApplicationData
{

    //--------------------------------------------------------------------------
    //
    //  Static Methods
    //
    //--------------------------------------------------------------------------
    public static function generateAuthorizeKey(data:VKApplicationData):String
    {
    	return MD5.encrypt(data.applicationId+"_"+data.viewerId+"_"+data.applicationSecretKey);
    }
    //--------------------------------------------------------------------------
    //
    //  Constaints
    //
    //--------------------------------------------------------------------------
    
    public static const SETTINGS_NOTIFICATIONS:int = 1;
    public static const SETTINGS_FRIENDS:int = 2;
    public static const SETTINGS_PHOTOS:int = 4;
    public static const SETTINGS_AUDIOS:int = 8;
    public static const SETTINGS_OFFERS:int = 32;
    public static const SETTINGS_QUESTIONS:int = 64;
    public static const SETTINGS_WIKI:int = 128;
    public static const SETTINGS_MENU:int = 256;
    public static const SETTINGS_WALLS:int = 512;
 
    
    private static const GROUP_ADMINISTRATOR:String = "3";
    private static const GROUP_LEADER:String = "2";
    private static const GROUP_MEMBER:String = "1";
    private static const GROUP_NOT_MEMBER:String = "0";

    private static const VIEW_PAGE_OWNER:String = "2";
    private static const VIEW_PAGE_OWNER_FRIEND:String = "1";
    private static const VIEW_PAGE_OWNER_NOT_FRIEND:String = "0";

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    public var apiURL:String = null;
	public var groupId:String = null;
	public var viewerType:String = null;
	public var settings:int;
	public var isUserInstallApplication:Boolean = false;
	public var authorizeKey:String = null;
	public var language:int = 0;
	public var apiResult:Object;
	public var userId:String = null;	
	
	private var _viewerId:String = null;
	private var _applicationId:String = null;
	private var _applicationSecretKey:String = null;
    private var _isApplicationSecretKeyChanged:Boolean;
    private var _autoGenerateAuthorizeKey:Boolean = false;
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function VKApplicationData(parameters:Object)
    {
        if(!parameters)
       		return;
       		
        isUserInstallApplication = parameters.is_app_user == "1";
        applicationId = parameters.api_id;
        userId = parameters.user_id;
        groupId = parameters.group_id;
        apiURL = parameters.api_url;
        apiResult = parameters.api_result;
        viewerId = parameters.viewer_id;
        viewerType = parameters.viewer_type;
        authorizeKey = parameters.auth_key;
        settings = parseInt(parameters.api_settings);
        language = parseInt(parameters.language);
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
	private function updateAuthorizeKeyIsNeed():void
	{
		if(isApplicationSecretKeyChanged && autoGenerateAuthorizeKey)
           authorizeKey = generateAuthorizeKey(this);    
	}
    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    public function get isUserGroupAdministrator():Boolean
    {
        return viewerType == GROUP_ADMINISTRATOR;
    }
    public function get isUserGroupLeader():Boolean
    {
        return viewerType == GROUP_LEADER;
    }
    public function get isUserGroupMember():Boolean
    {
        return viewerType == GROUP_MEMBER;
    }
    public function get isUserGroupNotMember():Boolean
    {
        return viewerType == GROUP_NOT_MEMBER;
    }

    public function isUserPageOwner():Boolean
    {
        return viewerType == VIEW_PAGE_OWNER;
    }
    public function isUserPageOwnerFriend():Boolean
    {
        return viewerType == VIEW_PAGE_OWNER_FRIEND;
    }
    public function isUserPageOwnerNotFriend():Boolean
    {
        return viewerType == VIEW_PAGE_OWNER_NOT_FRIEND;
    }
    
    public function get isUserAllowFriends():Boolean
    {
    	return settings >= 2;
    }   
    public function get isUserAllowMenu():Boolean
    {
    	return settings >= 256;
    }   
    //--------------------------------------------------------------------------
    //
    //  Private Properties
    //
    //--------------------------------------------------------------------------
    public function get isApplicationSecretKeyChanged():Boolean
    {
    	return _isApplicationSecretKeyChanged;
    }
    public function get autoGenerateAuthorizeKey():Boolean
    {
    	return _autoGenerateAuthorizeKey;
    }
    public function set autoGenerateAuthorizeKey(value:Boolean):void
    {
    	_autoGenerateAuthorizeKey = value;
    	updateAuthorizeKeyIsNeed();	
    }
    public function set isApplicationSecretKeyChanged(value:Boolean):void
    {
    	_isApplicationSecretKeyChanged = value;
       	updateAuthorizeKeyIsNeed();	 	
    }
    //--------------------------------------------------------------------------
    //
    //  Public Properties
    //
    //--------------------------------------------------------------------------
    public function get applicationSecretKey():String
    {
        return _applicationSecretKey;
    }

    public function set applicationSecretKey(value:String):void
    {
        _applicationSecretKey = value;
        isApplicationSecretKeyChanged = true;

    }

    public function get applicationId():String
    {
        return _applicationId;
    }

    public function set applicationId(value:String):void
    {
        _applicationId = value;
       isApplicationSecretKeyChanged = true;
    }

	public function get viewerId():String
	{
		return _viewerId;
	}	
    public function set viewerId(value:String):void
    {
        _viewerId = value;
        isApplicationSecretKeyChanged = true;
    }

}
}