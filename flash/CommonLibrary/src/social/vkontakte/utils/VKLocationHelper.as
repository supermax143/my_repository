package social.vkontakte.utils
{
	import social.vkontakte.transport.VKApi;
	import social.vkontakte.transport.VKErrorResponce;
	import social.vkontakte.transport.VKResponce;

public class VKLocationHelper
{
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	private var api:VKApi;
	private var user:Object;
	private var callback:Function;
	private var requestsCount:int = 0;
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function VKLocationHelper(api:VKApi, user:Object, callback:Function = null)
	{
		this.api = api;
		this.user = user;
		this.callback = callback;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Methods
	//
	//--------------------------------------------------------------------------	
	private function checkCallback():void
	{
		if(requestsCount > 0)
			return;
		if(callback != null)
			callback();
	}
	//--------------------------------------------------------------------------
	//
	//  Public Methods
	//
	//--------------------------------------------------------------------------	
	
	public function send(country:Boolean, city:Boolean):void
	{
		if(country)
		{
			api.getCountries(user.countryId,countryEventHandler,errorEventHandler);
			requestsCount++;
		}
		if(city)
		{
			api.getCities(user.cityId,cityEventHandler,errorEventHandler);
			requestsCount++;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event Handlers
	//
	//--------------------------------------------------------------------------	
	private function cityEventHandler(responce:VKResponce):void
	{
		var list:XMLList = responce.xmlData.descendants("city");
		var items:Object = new Object();
		for each(var item:XML in list)
			items[item.cid.text().toString()] = item.name.text().toString();
		
		user.city = items[user.cityId];
		requestsCount--;
		checkCallback();
	}
	private function countryEventHandler(responce:VKResponce):void
	{
		var list:XMLList = responce.xmlData.descendants("country");
		var items:Object = new Object();
		for each(var item:XML in list)
			items[item.cid.text().toString()] = item.name.text().toString();
		
		user.country = items[user.countryId];
		requestsCount--;
		checkCallback();
	}
	private function errorEventHandler(responce:VKErrorResponce):void
	{
		if(callback != null)
			callback(new Error(responce.errorMessage));
	}
	
}
}