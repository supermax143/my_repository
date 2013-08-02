package view.popup
{
	
	import feathers.controls.Panel;
	import feathers.controls.Scroller;
	import feathers.core.PopUpManager;
	
	import starling.display.Image;
	import starling.display.Quad;
	
	public class WindowBase extends Panel
	{
		
		//--------------------------------------------------------------------------
		//
		//  Static methods
		//
		//--------------------------------------------------------------------------
		public static function show(windowClass:Class,data:Object=null,modal:Boolean=true,isCentrate:Boolean=true):WindowBase
		{
			var window:WindowBase = new windowClass() 
			if(!(window is WindowBase))
			{
				throw new Error("Class is not WindowBase");
				return null;
			}
			window.data = data;
			PopUpManager.addPopUp(window,modal,isCentrate);
			return window;
		}

		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		private var _data:Object
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function WindowBase()
		{
			super();
			//width = 400;
			//height = 300;
			scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
		}
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		public function close():void
		{
			PopUpManager.removePopUp(this,true);
		}
		
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Protected Methods
		//
		//--------------------------------------------------------------------------
		protected function addContent():void
		{
			var bg:Quad = new Quad(width,height,0x555555);
			addChild(bg);
		}
		
		
	}
}