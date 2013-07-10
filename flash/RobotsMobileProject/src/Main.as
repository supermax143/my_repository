package
{
	import com.renaun.controls.VGroup;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Panel;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.core.FeathersControl;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	
	import flash.geom.PerspectiveProjection;
	
	import starling.display.Sprite;
	
	import view.dollview.screens.GameScreen;
	import view.dollview.screens.MainMenuScreen;
	
	public class Main extends Sprite
	{
		
		public static const MAIN_MENU:String = "mainMenu";
		public static const GAME_SCREEN:String = "gameScreen";
		
		private var theme:MetalWorksMobileTheme
		private var screenNavigator:ScreenNavigator;
		private var transitionManager:ScreenSlidingStackTransitionManager;
		
		
		public function Main()
		{
			
			theme = new MetalWorksMobileTheme(this.stage);
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
		}
	}
}