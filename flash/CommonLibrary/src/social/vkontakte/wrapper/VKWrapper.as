package social.vkontakte.wrapper
{
	
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
[Event(name="settingsChange", type="social.vkontakte.wrapper.VKWrapperEvent")] 
[Event(name="balanceChange", type="social.vkontakte.wrapper.VKWrapperEvent")] 
[Event(name="locationChange", type="social.vkontakte.wrapper.VKWrapperEvent")] 
[Event(name="mouseLeave", type="social.vkontakte.wrapper.VKWrapperEvent")] 
[Event(name="windowResize", type="social.vkontakte.wrapper.VKWrapperEvent")] 
[Event(name="windowFocusIn", type="social.vkontakte.wrapper.VKWrapperEvent")] 
[Event(name="windowFocusOut", type="social.vkontakte.wrapper.VKWrapperEvent")] 
[Event(name="applicationAdd", type="social.vkontakte.wrapper.VKWrapperEvent")] 
	
[Bindable]	
public class VKWrapper extends EventDispatcher
{
	//--------------------------------------------------------------------------
    //
    //  Static Methods
    //
    //-------------------------------------------------------------------------

	private static var _instance : VKWrapper;

	static public function get instance():VKWrapper
	{
		if(!_instance)
			_instance = new VKWrapper();
		return _instance;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
  
 	private var application:VKApplication;  
	private var wrapper:Object;
	
	private var external:Object;	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------    	
		
	public function VKWrapper()
	{
        if(_instance)
			throw new Error("Only one VKWrapper can exist in application");
	}
	private function setWrapper(value:Object):void
	{
		if(wrapper)
		{
			wrapper.removeEventListener("onBalanceChanged",balanceChangeHandler);		   	
			wrapper.removeEventListener("onSettingsChanged",settingsChangeHandler);		   	
			wrapper.removeEventListener("onLocationChanged",locationChangeHandler);		   	
			wrapper.removeEventListener("onMouseLeave",mouseLeaveHandler);		   	
			wrapper.removeEventListener("onWindowResized",windowResizeHandler);		   	
			wrapper.removeEventListener("onWindowFocus",windowFocusInHandler);		   	
			wrapper.removeEventListener("onWindowBlur",windowFocusOutHandler);				
			wrapper.removeEventListener("onApplicationAdded",applicationAddHandler);				
		}
		
		wrapper = value;
		
		if(wrapper)
		{
			wrapper.addEventListener("onBalanceChanged",balanceChangeHandler,false,0,true);		   	
			wrapper.addEventListener("onSettingsChanged",settingsChangeHandler,false,0,true);		   	
			wrapper.addEventListener("onLocationChanged",locationChangeHandler,false,0,true);		   	
			wrapper.addEventListener("onMouseLeave",mouseLeaveHandler,false,0,true);		   	
			wrapper.addEventListener("onWindowResized",windowResizeHandler,false,0,true);		   	
			wrapper.addEventListener("onWindowFocus",windowFocusInHandler,false,0,true);		   	
			wrapper.addEventListener("onWindowBlur",windowFocusOutHandler,false,0,true);				
			wrapper.addEventListener("onApplicationAdded",applicationAddHandler,false,0,true);				
		}
	}
    //--------------------------------------------------------------------------
    //
    //  Event Handler
    //
    //--------------------------------------------------------------------------
    private function applicationAddHandler(vkEvent:Object):void
    {
    	var event:VKWrapperEvent = new VKWrapperEvent(VKWrapperEvent.APPLICATION_ADD);
    	dispatchEvent(event);
    }
    private function balanceChangeHandler(vkEvent:Object):void
    {
    	var event:VKWrapperEvent = new VKWrapperEvent(VKWrapperEvent.BALANCE_CHANGE);
    	event.balance = vkEvent.balance;
    	dispatchEvent(event);
    }
    private function settingsChangeHandler(vkEvent:Object):void
    {
    	var event:VKWrapperEvent = new VKWrapperEvent(VKWrapperEvent.SETTINGS_CHANGE);
    	event.settings = vkEvent.settings;
    	dispatchEvent(event);
    }
    private function locationChangeHandler(vkEvent:Object):void
    {
    	var event:VKWrapperEvent = new VKWrapperEvent(VKWrapperEvent.LOCATION_CHANGE);
    	event.location = vkEvent.location;
    	dispatchEvent(event);
    }
    private function mouseLeaveHandler(vkEvent:Object):void
    {
    	var event:VKWrapperEvent = new VKWrapperEvent(VKWrapperEvent.MOUSE_LEAVE);
    	dispatchEvent(event);
    }
    private function windowResizeHandler(vkEvent:Object):void
    {
    	var event:VKWrapperEvent = new VKWrapperEvent(VKWrapperEvent.WINDOW_RESIZE);
    	event.width = vkEvent.width;
    	event.height = vkEvent.height;
    	dispatchEvent(event);
    }
    private function windowFocusInHandler(vkEvent:Object):void
    {
    	var event:VKWrapperEvent = new VKWrapperEvent(VKWrapperEvent.WINDOW_FOCUS_IN);
    	dispatchEvent(event);
    }
    private function windowFocusOutHandler(vkEvent:Object):void
    {
    	var event:VKWrapperEvent = new VKWrapperEvent(VKWrapperEvent.WINDOW_FOCUS_OUT);
    	dispatchEvent(event);
    }
    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------
    
    public function init(wrapper:Object):void
    {
 		setWrapper(wrapper);
 		if(!wrapper)
 			return;

		external = wrapper.external;
		application = new VKApplication(wrapper.application);			   	
    }
    
    public function getApplication():VKApplication
    {
    	return application;
    }
    public function showInstallBox():void
    {
    	if(external)
    		external.showInstallBox();
    }
    public function showSettingsBox(settings:uint = 0):void
    {
     	if(external)
    		external.showSettingsBox(settings);
    }
    public function showInviteBox():void
    {
    	if(external)
    		external.showInviteBox();
    }
    public function showPaymentBox(votes:uint = 0):void
    {
     	if(external)
    		external.showPaymentBox(votes);
    }
    public function saveWallPost(hash:String):void
    {
     	if(external)
    		external.saveWallPost(hash);
    }
    public function setSize(width:uint,height:uint):void
    {
    	if(external)
    		external.resizeWindow(width,height);
    }
    public function scrollWindow(top:uint,speed:uint):void
    {
    	if(external)
    		external.scrollWindow(top,speed);
    }
    public function setTitle(title:String):void
    {
     	if(external)
    		external.setTitle(title);
    }
    public function setLocation(location:String):void
    {
    	if(external)
    		external.setLocation(location);
    }
    public function setNavigation(labels:Array,links:Array):void
    {
     	if(external) 
    		external.setNavigation(labels,links);
    }
    public function navigateToURL(request:URLRequest):void
    {
    		external.navigateToURL(request);
    }
}
}