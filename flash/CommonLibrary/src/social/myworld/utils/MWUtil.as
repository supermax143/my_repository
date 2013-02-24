package social.myworld.utils
{
	import social.myworld.data.IMWUser;
	
public class MWUtil
{
	public static function copyMWUserProperties(formUser:Object,toUser:Object):void
	{
		if(!formUser || !toUser)
			return;
			
     	toUser.photoSmallURL = formUser.photoSmallURL;
     	toUser.photoBigURL = formUser.photoBigURL;
     	toUser.photoMediumURL = formUser.photoMediumURL;
     	
     	toUser.id = formUser.id;
     	toUser.firstName = formUser.firstName;
     	toUser.lastName = formUser.lastName;
     	toUser.nickname = formUser.nickname;
     	toUser.city = formUser.city;
     	toUser.country = formUser.country;
     	toUser.region = formUser.region;
     	toUser.sex = formUser.sex;
     	//toUser.bdate = formUser.bdate;
     	toUser.isMale = formUser.isMale;
		toUser.label = formUser.label;
		toUser.link = formUser.link;
	}
}
}