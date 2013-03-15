package view.dollview
{
	import dragonBones.factorys.BaseFactory;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	internal class FactoriesManager
	{
		private static var factoriesDictionary:Dictionary = new Dictionary(true);
		private static var initiolizingFactories:ArrayCollection = new ArrayCollection();
		
		public function FactoriesManager()
		{
			
		}
		
		public static function addFactory(resource:ByteArray,factoryInitedHandler:Function):void
		{
			var factory:BaseFactory = factoriesDictionary[resource]
			if(!factory)
			{
				factory = new BaseFactory();
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
			initiolizingFactories.addItem(factory);
		}
		
		private static function removeInitFactory(factory:BaseFactory):void
		{
			initiolizingFactories.removeItemAt(initiolizingFactories.getItemIndex(factory));
		}
		
		private static function isFactoryInitiolizing(factory:BaseFactory):Boolean
		{
			for each (var f:BaseFactory in initiolizingFactories) 
			{
				if(f==factory)
					return true;
			}
			return false;
			
		}
		
	}
}