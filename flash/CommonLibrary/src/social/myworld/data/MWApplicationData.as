package social.myworld.data
{
public class MWApplicationData
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	public var isUserInstallApplication:Boolean;
	public var applicationID:String;
	public var windowID:String;
	public var viewerID:String;
	public var holderID:String;
	public var state:String;
	public var settings:String;
	public var authorizeKey:String;
	public var privateKey:String;
	public var sessionKey:String;
	public var permissions:String;


    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function MWApplicationData(parameters:Object = null)
    {
        if(!parameters)
       		return;

        applicationID = parameters.app_id;
        windowID  = parameters.window_id;
        state = parameters.state;
        settings = parameters.settings;

        viewerID = parameters.vid;
        holderID = parameters.oid;
        authorizeKey = parameters.authentication_key;
        sessionKey = parameters.session_key;
        permissions = parameters.ext_perm;
        isUserInstallApplication = parameters.is_app_user == "1";        
    }

    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------



}
}