package social.vkontakte.wrapper
{
	import flash.events.Event;

public class VKWrapperEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
	
	public static const APPLICATION_ADD:String = "applicationAdd";
	public static const SETTINGS_CHANGE:String = "settingsChange";
	public static const BALANCE_CHANGE:String = "balanceChange";

	public static const LOCATION_CHANGE:String = "locationChange";
	public static const MOUSE_LEAVE:String = "mouseLeave";
	
	public static const WINDOW_RESIZE:String = "windowResize";	
	public static const WINDOW_FOCUS_IN:String = "windowFocusIn";
	public static const WINDOW_FOCUS_OUT:String = "windowFocusOut";

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    public var settings:Number;
    public var balance:Number;
    public var width:Number;
    public var height:Number;
    public var location:String;
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------    	
	
	public function VKWrapperEvent(type:String)
	{
		super(type);
	}
	
}
}