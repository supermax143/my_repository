package social.vkontakte.utils
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	import social.vkontakte.data.*;
	import social.vkontakte.transport.*;
	
public class VKUtil
{
    //--------------------------------------------------------------------------
    //
    //  Public Static Methods
    //
    //-------------------------------------------------------------------------- 
    	
	public static function getAccountPageURL(uid:String):String
	{
		return "http://vkontakte.ru/id"+uid;
	}
	public static function openAccountPage(uid:String,window:String = "_blank"):void
	{
		navigateToURL(new URLRequest(getAccountPageURL(uid)),"_blank");
	}
	public static function isValidUID(uid:Object):Boolean
	{
		var id:Number = parseInt(uid.toString());
		if(isNaN(id))
			return false;
		return int(id) > 0;
	}
	public static function getUIDs(responce:VKResponce):String
	{
		if(!responce)
			return null;
			
		var uids:XMLList = responce.xmlData.descendants("uid");
		var uidsString:String = new String();
		var uidsLength:int = uids.length();
		for (var i:int = 0; i < uidsLength; i++)
		{
			var uidXML:XML = uids[i] as XML;
			uidsString += uidXML.text().toString();
			if(i != uidsLength - 1)
				uidsString += ",";
		}			
		return uidsString;
	}
	public static function getUploadURL(responce:VKResponce):String
	{
		var list:XMLList = responce.xmlData.descendants("upload_url");
		return list.length() > 0? list[0].toString():null;
	}
	public static function getWallPostHash(responce:VKResponce):String
	{
		var list:XMLList = responce.xmlData.descendants("post_hash");
		return list.length() > 0? list[0].toString():null;
	}
	public static function getBalance(responce:VKResponce):Number
	{		
		return responce? Number(responce.xmlData.balance): NaN
	}

	public static function setUserCity(user:Object,responce:VKResponce):void
	{
		if(!responce)
			return;
		var citiesXMLList:XMLList = responce.xmlData.descendants("city");
		for each(var cityXML:XML in citiesXMLList)
		{
			var cityId:int = parseInt(cityXML.cid.text().toString());
			if(user.cityId == cityId)
				user.city = cityXML.name.text().toString();	
		}		
	}
	public static function copyVKUserProperties(formUser:Object,toUser:Object):void
	{
		if(!formUser || !toUser)
			return;
			
     	toUser.photoSmallURL = formUser.photoSmallURL;
     	toUser.photoMediumURL = formUser.photoMediumURL;
     	toUser.photoBigURL = formUser.photoBigURL;
     	
     	toUser.id = formUser.id;
     	toUser.firstName = formUser.firstName;
     	toUser.lastName = formUser.lastName;
     	toUser.nickname = formUser.nickname;
     	toUser.sex = formUser.sex;
     	toUser.birthday = formUser.birthday;
     	toUser.birthdayString = formUser.birthdayString;
     	toUser.cityId = formUser.cityId;
     	toUser.city = formUser.city;
     	toUser.countryId = formUser.countryId;
     	toUser.country = formUser.country;
     	toUser.timezone = formUser.timezone;
     	toUser.country = formUser.country;
     	toUser.isInstallApplication = formUser.isInstallApplication;
     	toUser.isMale = formUser.isMale;
     	toUser.balance = formUser.balance;			
     	toUser.rate = formUser.rate;			
     	toUser.hasMobile = formUser.hasMobile;			
	}

    public static function isValidAdvertisement(advertisement:VKAdvertisement):Boolean
    {
    	if(!advertisement || advertisement.link == null || advertisement.link.length == 0)
    		return false;
    	return advertisement.link.indexOf("vkontakte.ru") > -1 || 
    		   advertisement.link.indexOf("vk.com") > -1; 
    }	
}
}