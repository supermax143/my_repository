package vk
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	
	import vk.api.serialization.json.JSON;

	/**
	 * @author Sergey Vanichkin aka ALiEN
	 */
	public class VKontakteJS 
	{
		
		private static var _eventDispatcher:EventDispatcher = new EventDispatcher ();
		
		public static const FULL_USER_INFO:String = "uid,first_name,last_name,nickname,sex," +
			"bdate,city,country,timezone,photo,photo_medium,photo_big,has_mobile,rate";
		
		
		public static function addEventListener ( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			/** подпишемся, если еще не подписаны */
			//ExternalInterface.call( "VK.addCallback", type );
			_eventDispatcher.addEventListener ( type, listener, useCapture, priority, useWeakReference );
		}
		
		public static function removeEventListener ( type:String, listener:Function, useCapture:Boolean = false ):void
		{
			_eventDispatcher.removeEventListener ( type, listener, useCapture ); 
		}
		
		public static var params:Object;
		
		private static var _guiCommands:Array = [ 	
													"showInstallBox", 
													"showSettingsBox", 
													"showInviteBox", 
													"showPaymentBox",
													"showMerchantPaymentBox", 
													"showProfilePhotoBox", 
													"saveWallPost", 
													"resizeWindow",
													"showOrderBox",
													"scrollWindow", 
													"setTitle", 
													"setLocation" 
												];
												
		public static function call ( type:String, param1:* = null, param2:* = null ):void
		{
			if ( _guiCommands.indexOf ( type ) > -1 )
			{
				ExternalInterface.call ( "VK.callMethod", type, param1, param2 );
			}
			else
			{
				param1.test_mode=1,
				ExternalInterface.call("callApi", type, param1 );
			}
		}
		
		
		public static function getFullProfiles(uids:String,handler:Function):void
		{
			
		}	
		
		//----------------------------------------------------------------------------
		
		public static function init():void
		{
			/** куда будут приходить эвенты от JS */
			
			ExternalInterface.addCallback( "sendToFlash", _fromJS );
			
		}

		private static function _fromJS(type:String,data:Object ):void 
		{
			var event:String = type;
			var params:Object = data.response;
			var error:Array;
			
			
			
			VKontakteJS.params = params;
			_eventDispatcher.dispatchEvent ( new Event ( event) );
			
		}
	}
}
