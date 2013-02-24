package social.myworld.utils
{
	import social.myworld.data.MWUser;
	import social.myworld.transport.MWResponce;
	import social.vkontakte.data.VKAdvertisement;
	
public class MWSerialization
{
    //--------------------------------------------------------------------------
    //
    //  Users
    //
    //--------------------------------------------------------------------------    	
	public static function serializeUsers(responce:MWResponce):Array
	{
		var array:Array = new Array();
		var users:XMLList = responce.xmlData.descendants("user");
		return serializeUsersByXML(users);
	}
	public static function serializeUser(responce:MWResponce):MWUser
	{
		var userData:XML = responce.xmlData.user[0] as XML;
		if(userData)
			return serializeUserByXML(userData);
		else
			return null;
	}

	public static function serializeUsersByXML(usersData:XMLList):Array
	{
		var array:Array = new Array();
		for each(var userData:XML in usersData)
			array.push(serializeUserByXML(userData));
		return array;
	}
	public static function serializeUserByXML(userData:XML):MWUser
	{	
		var user:MWUser = new MWUser();	
							
		user.id = userData["uid"];
		user.firstName = userData["first_name"];
		user.lastName = userData["last_name"];
		user.nickname = userData["nick"];
		user.birthdayString = userData["birthday"];
		user.birthday = parseDate(user.birthdayString);		
		
		user.sex = userData["sex"];
		user.photoSmallURL = userData["pic_small"];
		user.photoMediumURL = userData["pic"];
		user.photoBigURL = userData["pic_big"];
		user.photoMediumURL = userData["pic"];
		user.reffererID = userData["referer_id"];
		user.reffererType = userData["referer_type"];
		user.link = userData["link"];
		
		var city:XMLList = userData.descendants("city");
		if(city && city.length() == 1)
			user.city = {id: city[0].id.toString(), name: city[0].name.toString()};
		
		var country:XMLList = userData.descendants("country");
		if(country && country.length() == 1)
			user.country = {id: country[0].id.toString(), name: country[0].name.toString()};
		
		var region:XMLList = userData.descendants("region");
		if(region && region.length() == 1)
			user.region = {id: region[0].id.toString(), name: region[0].name.toString()};
		
		return user;		
	}
	
    //--------------------------------------------------------------------------
    //
    //  Public Static Methods
    //
    //--------------------------------------------------------------------------	
    
	private static function parseDate(dateString:String):Date
	{
		if(!dateString || dateString.length == 0)
			return null;
			
		var dateValues:Array = dateString.split(".");
		var day:Number = Number(dateValues[0]);
		var month:Number = Number(dateValues[1]);
		var year:Number = dateValues.length > 2? Number(dateValues[2]) : null;
		
		var date:Date = new Date(year,month - 1,day);
		return date;
	}
	
	public static function serializeAdvertisementByXML(adData:XML):VKAdvertisement
	{	
		var advertisement:VKAdvertisement = new VKAdvertisement();	
		advertisement.description = adData.description.toString();
		advertisement.link = adData.url.toString();
		advertisement.photo = adData.image.toString();
		advertisement.title = adData.title.toString();
		return advertisement;		
	}
}
}