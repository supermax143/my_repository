package controller.transport
{
	import io.socket.flash.ISocketIOTransport;
	import io.socket.flash.ISocketIOTransportFactory;
	import io.socket.flash.SocketIOErrorEvent;
	import io.socket.flash.SocketIOEvent;
	import io.socket.flash.SocketIOTransportFactory;
	import io.socket.flash.WebsocketTransport;
	
	import org.osflash.signals.Signal;

	public class Transport
	{
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		private var ioSocket:ISocketIOTransport;
		private var socketIOTransportFactory:ISocketIOTransportFactory;
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		public var connectedSignal:Signal;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function Transport()
		{
			connectedSignal = new Signal()
			socketIOTransportFactory = new SocketIOTransportFactory();
			ioSocket = socketIOTransportFactory.createSocketIOTransport(WebsocketTransport.TRANSPORT_TYPE, "localhost:8080/socket.io", RobotsWebProject.instance);
			ioSocket.addEventListener(SocketIOEvent.CONNECT, ioSocketConnectHandler);
			ioSocket.addEventListener(SocketIOEvent.DISCONNECT, ioSocketDisconnectHandler);
			ioSocket.addEventListener(SocketIOEvent.MESSAGE, ioSocketMessageHandler);
			ioSocket.addEventListener(SocketIOErrorEvent.CONNECTION_FAULT, ioSocketConnectionFaultHandler);
			ioSocket.addEventListener(SocketIOErrorEvent.SECURITY_FAULT, ioSocketSecurityFaultHandler);
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		public function sendMessage(type:String,data:Object):void
		{
			ioSocket.send({type:type,data:data});
		}
		
		public function connect():void
		{
			ioSocket.connect();
		}
			
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function log(...args):void 
		{
			trace(args.join(' '))
		}
		
		private function ioSocketConnectHandler(e:SocketIOEvent):void 
		{
			ioSocket.removeEventListener(SocketIOEvent.CONNECT, ioSocketConnectHandler);
			connectedSignal.dispatch();
			//log('CONNECTED:', e.target, ', ', e.message);
			//ioSocket.send({type: 'register', data: "Wooowwww"});
		}
		
		private function ioSocketDisconnectHandler(e:SocketIOEvent):void 
		{
			log("DISCONNECTED:", e.target);
		}
		
		private function ioSocketMessageHandler(e:SocketIOEvent):void 
		{
			log('==========');
			log('MESSAGE: ', e.message.type);
		}
		
		private function ioSocketConnectionFaultHandler(e:SocketIOErrorEvent):void 
		{
			log('FAULT:', e.type, ":", e.text);
		}
		
		private function ioSocketSecurityFaultHandler(e:SocketIOErrorEvent):void 
		{
			log('SECURITY FAULT:', e.type, ":", e.text);
		}
		
	}
}