package
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.core.PopUpManager;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	
	import view.popup.LoginWindow;
	import view.popup.WindowBase;
	import view.screens.GameScreen;
	import view.screens.MainMenuScreen;
	
	public class Main extends Sprite
	{
		
		public static const MAIN_MENU:String = "mainMenu";
		public static const GAME_SCREEN:String = "gameScreen";
		
		private var theme:MetalWorksMobileTheme
		private var screenNavigator:ScreenNavigator;
		private var transitionManager:ScreenSlidingStackTransitionManager;
		
		
		
		
		public function Main()
		{
			theme = new MetalWorksMobileTheme(this.stage,false);
			screenNavigator = new ScreenNavigator();
			screenNavigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen,
				{
					gameScreen: GAME_SCREEN
				}));
			screenNavigator.addScreen(GAME_SCREEN, new ScreenNavigatorItem(GameScreen,
				{
					mainMenu: MAIN_MENU
				}));
			screenNavigator.showScreen(MAIN_MENU);
			addChild(screenNavigator);
			transitionManager = new ScreenSlidingStackTransitionManager(screenNavigator);
			transitionManager.duration = 0.4;
			
			WindowBase.show(LoginWindow);
			
		}
	}
}