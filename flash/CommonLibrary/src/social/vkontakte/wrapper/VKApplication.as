package social.vkontakte.wrapper
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
[Bindable]	
public class VKApplication
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
   
    public var parameters:Object;
    public var quality:String;
    public var scaleMode:String;
    public var align:String;
    public var frameRate:String;
    public var stageWidth:Number;
    public var stageHeight:Number;
    
    private var application:Object;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------    	
	    
	public function VKApplication(application:Object)
	{
		if(application)
			init(application);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------
    public function init(application:Object):void
    {
		this.application = application;
		parameters = application.parameters;
		quality = application.quality;
		scaleMode = application.scaleMode;
		align = application.align;
		frameRate = application.frameRate;
		stageWidth = application.stageWidth;
		stageHeight = application.stageHeight;  	
    }	
	
}
}