package social.myworld.data
{
public class MWUser implements IMWUser
{
   //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    public static const SEX_MALE:int = 0;
    public static const SEX_FEMALE:int = 1;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
  
    private var _firstName:String;
    private var _lastName:String;
    private var _nickname:String;
	private var _sex:int;	

	public var birthday:Date;
	public var birthdayString:String;	
	public var photoSmallURL:String;
	public var photoBigURL:String;
	public var photoMediumURL:String;
	
	public var id:String;
	public var link:String;	
	public var label:String;
	public var reffererType:String;
	public var reffererID:String;
    
	public var isMale:Boolean
	public var date:String;
    public var balance:Number;
	
    public var city:Object;
    public var country:Object;
    public var region:Object;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function MWUser()
    {
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
     	object.photoBigURL = photoBigURL;
     	object.photoMediumURL = photoMediumURL;
     	
     	object.id = id;
     	object.firstName = firstName;
     	object.lastName = lastName;
     	object.nickname = nickname;
     	object.sex = sex;
     	object.birthday = birthday;
     	object.reffererType = reffererType;
     	object.reffererID = reffererID;
     	object.link = link;
     	object.city = city;
     	object.country = country;
     	object.region = region;

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