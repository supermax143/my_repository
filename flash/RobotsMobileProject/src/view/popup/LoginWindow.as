package view.popup
{
	import com.renaun.controls.HGroup;
	import com.renaun.controls.VGroup;
	
	import controller.Controller;
	
	import feathers.controls.Button;
	import feathers.controls.Panel;
	import feathers.controls.TextInput;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class LoginWindow extends WindowBase
	{
		
		private var nameInput:TextInput;
		private var loginButton:Button;
		
		public function LoginWindow()
		{
			super();
			width = 300;
			height = 300;
			addContent();
			
		}
		
		override protected function addContent():void
		{
			super.addContent();
			var group:VGroup = new VGroup();
		
			nameInput = new TextInput();
			group.addLayoutItem(nameInput);
			
			loginButton = new Button();
			loginButton.addEventListener(Event.TRIGGERED,login);
			loginButton.label = 'login'
			group.addLayoutItem(loginButton);
			addChild(group);
		}
		
		private function login(event:Event):void
		{
			if(!nameInput.text)
				return;
			
			Controller.instance.login(nameInput.text);
		}
		
	}
}