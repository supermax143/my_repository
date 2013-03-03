package dollview
{
	import dragonBones.factorys.BaseFactory;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	internal class FactoriesManager
	{
		private static var factoriesDictionary:Dictionary = new Dictionary(true);
		
		
		public function FactoriesManager()
		{
			
		}
		
		public static function addFactory(resource:ByteArray,factoryInitedHandler:Function):void
		{
			var factory:BaseFactory = factoriesDictionary[resource]
			if(!factory)
			{
				factory = new BaseFactory();
				factoriesDictionary[resource] = factory; 
				factory.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					factoryInitedHandler(factory);
				});
				factory.parseData(resource);
			}
			else
			{
				factoryInitedHandler(factory);
			}
				
		}
		
	}
}