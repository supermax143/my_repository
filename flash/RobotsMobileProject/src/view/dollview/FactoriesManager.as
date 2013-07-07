package view.dollview
{
	import dragonBones.factorys.BaseFactory;
	import dragonBones.factorys.StarlingFactory;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	internal class FactoriesManager
	{
		private static var factoriesDictionary:Dictionary = new Dictionary(true);
		private static var initiolizingFactories:Dictionary = new Dictionary(true);
		
		public function FactoriesManager()
		{
			
		}
		
		public static function addFactory(resource:ByteArray,factoryInitedHandler:Function):void
		{
			var factory:StarlingFactory = factoriesDictionary[resource]
			if(!factory)
			{
				factory = new StarlingFactory();
				//factory.scaleForTexture = 1;
				addInitFactory(factory);
				factoriesDictionary[resource] = factory; 
				factory.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					removeInitFactory(factory);
					factoryInitedHandler(factory);
				});
				factory.parseData(resource);
			}
			else if(isFactoryInitiolizing(factory))
			{
				factory.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					factoryInitedHandler(factory);
				});
			}
			else
			{
				factoryInitedHandler(factory);
			}
				
		}
		
		private static function addInitFactory(factory:BaseFactory):void
		{
			initiolizingFactories[factory] = factory;
		}
		
		private static function removeInitFactory(factory:BaseFactory):void
		{
			initiolizingFactories[factory] = null;
		}
		
		private static function isFactoryInitiolizing(factory:BaseFactory):Boolean
		{
			if(initiolizingFactories[factory] != null)
			{
				return true;
			}
			
			return false;
		}
		
	}
}