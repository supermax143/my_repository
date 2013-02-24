package social.common.user
{	
	import social.common.ResourceType;
	import social.myworld.data.IMWUser;
	import social.myworld.data.MWUser;
	import social.vkontakte.data.IVKUser;
	import social.vkontakte.data.VKUser;
	
[Bindable]
public class SocialUser implements IVKUser,IMWUser
{


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _resource:int = ResourceType.EX;
    private var _photoSmallURL:String;
    private var _photoBigURL:String;
    
    private var _id:String;
    
    private var _firstName:String;
    private var _lastName:String;
    private var _nickname:String;
    private var _label:String;
    private var _language:String;
    
    private var _sex:int;
    private var _isMale:Boolean;
	private var _birthdayString:String;    
    private var _birthday:Date;
    private var _date:String;
 
    private var _isInstallApplication:Boolean;
    private var _balance:Number;
    
    // VK Properties
    private var _photoMediumURL:String;
    private var _timezone:Number;       
    private var _cityId:int;
    private var _city:String; 
    private var _country:String;
    private var _countryId:int;
    private var _hasMobile:Boolean;
    private var _rate:Number;
	private var _region:Object;
        
    // MW Properties
    private var _link:String;
    private var _reffererID:String;
    private var _reffererType:String;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function SocialUser()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
	private function updateSex():void
	{
		switch(resource)
		{
			case(ResourceType.VK):
			isMale = sex == VKUser.SEX_MALE;
			break;
			case(ResourceType.MW):
			isMale = sex == MWUser.SEX_MALE;
			break;
		}
	}
    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    public function toString(includeNickname:Boolean = false,
    	userNonBreakableSpace:Boolean = true):String
    {
        var name:String = new String();
        var space:String = userNonBreakableSpace? String.fromCharCode(160):" ";
        if(firstName)
        	name += firstName;
        if(nickname && includeNickname)
        	name += space+nickname;
        if(lastName)
        	name += space+lastName;
		return name;
    }
    public function toObject():Object
    {
     	var object:Object = new Object();
     	object.photoSmallURL = photoSmallURL;
     	object.photoMediumURL = photoMediumURL;
     	object.photoBigURL = photoBigURL;
     	
     	object.id = id;
     	object.firstName = firstName;
     	object.lastName = lastName;
     	object.nickname = nickname;
     	object.sex = sex;
		object.birthdayString = birthdayString;
     	object.birthday = birthday;
     	object.cityId = cityId;
     	object.city = city;
     	object.countryId = countryId;
     	object.country = country;
     	object.timezone = timezone;
     	object.country = country;
     	object.isInstallApplication = isInstallApplication;
     	object.isMale = isMale;
     	object.balance = balance;
     	object.label = label;
     	object.language = language;
     	return object;
    }
    //--------------------------------------------------------------------------
    //
    //  Public Properties
    //
    //--------------------------------------------------------------------------
    public function get isMale():Boolean
    {
        return _isMale;
    }
    public function set isMale(value:Boolean):void
    {
        _isMale = value;
    }    
    public function get isInstallApplication():Boolean
    {
        return _isInstallApplication;
    }

    public function set isInstallApplication(value:Boolean):void
    {
        _isInstallApplication = value;
    }

    public function get id():String
    {
        return _id;
    }

    public function set id(value:String):void
    {
        _id = value;
    }

    public function get firstName():String
    {
        return _firstName;
    }

    public function set firstName(value:String):void
    {
        _firstName = value;
        label = toString();
    }
    
    public function get label():String
    {
        return _label;
    }

    public function set label(value:String):void
    {
        _label = value;
    }
    public function get language():String
    {
        return _language;
    }

    public function set language(value:String):void
    {
        _language = value;
    }

    public function get lastName():String
    {
        return _lastName;
    }

    public function set lastName(value:String):void
    {
        _lastName = value;
        label = toString();
    }

    public function get timezone():Number
    {
        return _timezone;
    }

    public function set timezone(value:Number):void
    {
        _timezone = value;
    }
    public function get balance():Number
    {
        return _balance;
    }

    public function set balance(value:Number):void
    {
        _balance = value;
    }

    public function get photoSmallURL():String
    {
        return _photoSmallURL;
    }

    public function set photoSmallURL(value:String):void
    {
        _photoSmallURL = value;
    }

    public function get photoMediumURL():String
    {
        return _photoMediumURL;
    }

    public function set photoMediumURL(value:String):void
    {
        _photoMediumURL = value;
    }

    public function get photoBigURL():String
    {
        return _photoBigURL;
    }
    public function set photoBigURL(value:String):void
    {
        _photoBigURL = value;
    }
    public function get nickname():String
    {
        return _nickname;
    }
    public function set nickname(value:String):void
    {
        _nickname = value;
        label = toString();
    }
    public function get sex():int
    {
        return _sex;
    }
    public function set sex(value:int):void
    {
        _sex = value;
        updateSex();
    }
    public function get date():String
    {
        return _date;
    }
    public function set date(value:String):void
    {
        _date = value;
    }  
    public function get birthday():Date
    {
        return _birthday;
    }
    public function set birthday(value:Date):void
    {
        _birthday = value;
        date = birthday.toDateString();
    }
    public function get cityId():int
    {
        return _cityId;
    }
    public function set cityId(value:int):void
    {
        _cityId = value;
    }   
    public function get city():String
    {
        return _city;
    }
    public function set city(value:String):void
    {
        _city = value;
    }   
    public function get country():String
    {
        return _country;
    }
    public function set country(value:String):void
    {
        _country = value;
    }
    public function get countryId():int
    {
        return _countryId;
    }
    public function set countryId(value:int):void
    {
        _countryId = value;
    }
    public function get rate():Number
    {
        return _rate;
    }
    public function set rate(value:Number):void
    {
        _rate = value;
    }
    public function get hasMobile():Boolean
    {
        return _hasMobile;
    }
    public function set hasMobile(value:Boolean):void
    {
        _hasMobile = value;
    }
    public function get reffererID():String
    {
        return _reffererID;
    }
    public function set reffererID(value:String):void
    {
        _reffererID = value;
    }
    
    public function get reffererType():String
    {
        return _reffererType;
    }
    public function set reffererType(value:String):void
    {
        _reffererType = value;
    }    
    public function get link():String
    {
        return _link;
    }
    public function set link(value:String):void
    {
        _link = value;
    }    
    public function get resource():int
    {
        return _resource;
    }
    public function set resource(value:int):void
    {
        _resource = value;
    }    

	public function get region():Object
	{
		return _region;
	}

	public function set region(value:Object):void
	{
		_region = value;
	}

	public function get birthdayString():String
	{
		return _birthdayString;
	}

	public function set birthdayString(value:String):void
	{
		_birthdayString = value;
	}


}
}