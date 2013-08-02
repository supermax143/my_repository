package controller
{
	import controller.messages.client.LoginMessageClient;
	import controller.transport.Transport;

	public class WebController extends Controller
	{
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var transport:Transport;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function WebController()
		{
			transport = new Transport();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		override public function init():void
		{
			transport.connectedSignal.addOnce(initedHandler);
			transport.connect();
		}
		
		
		
		override public function login(name:String):void
		{
			var message:LoginMessageClient = new LoginMessageClient(name);	
			transport.sendMessage(message.type,message.getData());		
		}
		
	}
}