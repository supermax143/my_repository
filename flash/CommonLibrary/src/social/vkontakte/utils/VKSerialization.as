package social.vkontakte.utils
{
	import social.vkontakte.data.VKAdvertisement;
	import social.vkontakte.data.VKAlbum;
	import social.vkontakte.data.VKUser;
	import social.vkontakte.transport.VKResponce;
	
public class VKSerialization
{
    //--------------------------------------------------------------------------
    //
    //  Photo Albums
    //
    //--------------------------------------------------------------------------
	public static function serializePhotoAlbums(responce:VKResponce):Array
	{
		var array:Array = new Array();
		var list:XMLList = responce.xmlData.descendants("album");
		return serializePhotoAlbumsByXML(list);
	}
	public static function serializePhotoAlbumsByXML(list:XMLList):Array
	{
		var array:Array = new Array();
		for each(var data:XML in list)
			array.push(serializePhotoAlbumByXML(data));
		return array;
	}	
	public static function serializePhotoAlbumByXML(data:XML):VKAlbum
	{	
		var album:VKAlbum = new VKAlbum();	
		album.id = data.aid.toString();
		album.description = data.description.toString();
		album.title = data.title.toString();
		album.thumbId = data.thumb_id.toString();
		album.ownerId = data.owner_id.toString();
		album.created = parseInt(data.created.toString());
		album.updated = parseInt(data.updated.toString());
		album.size = parseInt(data.size.toString());
		album.privacy = parseInt(data.privacy.toString());

		return album;		
	}	    	
    //--------------------------------------------------------------------------
    //
    //  Advertisement
    //
    //--------------------------------------------------------------------------
	public static function serializeAdvertisement(responce:VKResponce):Array
	{
		var array:Array = new Array();
		var ads:XMLList = responce.xmlData.descendants("ad");
		return serializeAdvertisementsByXML(ads);
	}
	public static function serializeAdvertisementsByXML(adsData:XMLList):Array
	{
		var array:Array = new Array();
		for each(var adData:XML in adsData)
			array.push(serializeAdvertisementByXML(adData));
		return array;
	}	
	public static function serializeAdvertisementByXML(adData:XML):VKAdvertisement
	{	
		var advertisement:VKAdvertisement = new VKAdvertisement();	
		advertisement.description = adData.description.toString();
		advertisement.link = adData.link.toString();
		advertisement.photo = adData.photo.toString();
		advertisement.title = adData.title.toString();
		return advertisement;		
	}	    	
    //--------------------------------------------------------------------------
    //
    //  Users
    //
    //--------------------------------------------------------------------------    	
	public static function serializeUsers(responce:VKResponce):Array
	{
		var array:Array = new Array();
		var users:XMLList = responce.xmlData.descendants("user");
		return serializeUsersByXML(users);
	}
	public static function serializeUser(responce:VKResponce):VKUser
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
	public static function serializeUserByXML(userData:Object):VKUser
	{	
		var user:VKUser = new VKUser();		
		user.id = userData["uid"];
		user.firstName = userData["first_name"];
		user.lastName = userData["last_name"];
		user.nickname = userData["nickname"];

		user.birthdayString = userData["bdate"];
		user.birthday = parseDate(user.birthdayString);
		user.cityId = userData["city"];
		user.countryId = userData["country"];
		user.sex = userData["sex"];
		user.timezone = userData["timezone"];
		user.photoSmallURL = userData["photo"];
		user.photoMediumURL = userData["photo_medium"];
		user.photoBigURL = userData["photo_big"];
		user.hasMobile = userData["has_mobile"] == "1";
		user.rate = parseInt(userData["rate"]);
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

}
}