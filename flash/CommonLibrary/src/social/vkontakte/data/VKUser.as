package social.vkontakte.data
{
	import social.vkontakte.utils.VKUtil;
	
[Bindable]
public class VKUser implements IVKUser
{

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    public static const SEX_MALE:int = 2;
    public static const SEX_FEMALE:int = 1;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	public var photoSmallURL:String;
	public var photoMediumURL:String;
	public var photoBigURL:String;
    
	public var id:String;
    
	private var _firstName:String;
	private var _lastName:String;
	private var _nickname:String;
	public var label:String;
	public var language:String;
    
	private var _sex:int;
	public var isMale:Boolean;
        
	public var birthday:Date;
	public var birthdayString:String;
	public var timezone:Number;
        
	public var cityId:int;
	public var city:String;
    
	public var country:String;
	public var countryId:int;
	public var hasMobile:Boolean;
    
	public var isInstallApplication:Boolean;
	public var balance:Number;
	public var rate:Number;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function VKUser()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

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
     	object.birthday = birthday;
     	object.birthdayString = birthdayString;
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
     	return object;
    }
    //--------------------------------------------------------------------------
    //
    //  Public Properties
    //
    //-------------------------------------------------------------------------- 
    public function get firstName():String
    {
        return _firstName;
    }

    public function set firstName(value:String):void
    {
        _firstName = value;
        label = toString();
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
        isMale = sex == SEX_MALE;
    }
}
}