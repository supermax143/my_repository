package com.renaun.controls
{
import feathers.core.FeathersControl;

import starling.display.DisplayObject;

public class VGroup extends Group
{
	public function VGroup()
	{
		super();
	
	}

	public var gap:int = 8;
	public var paddingLeft:int = 8;
	public var paddingRight:int = 8;
	public var paddingTop:int = 8;
	public var paddingBottom:int = 8;
	
	override protected function measure():void
	{
		var item:DisplayObject;
		explicitTotal = -gap;
		percentTotalValue = 0;
		var i:int;
		for (i = 0; i < children.length; i++)
		{
			item = children[i];
			if (childrenPercentValues[i] > 0)
				percentTotalValue += childrenPercentValues[i];
			else
			{
			
				if (item is FeathersControl)
				{
					//item.height = (item as BitmapFontTextRenderer).measureText().y;
					(item as FeathersControl).validate();
				}
				explicitTotal = explicitTotal + item.height;
			}		
			explicitTotal += gap;
		}
		isValid = true;
	}
	
	override protected function draw():void
	{
		// Delay items width/height are still not valid inside initalize method so have to wait for draw
		if (isFirstTime)
		{
			measure();
			isFirstTime = false;
		}
		var availableHeightForPercents:Number = explicitHeight - explicitTotal - paddingTop - paddingBottom;
		//trace("availableHeightForPercents: " + availableHeightForPercents + " - " + explicitTotal + " - " + explicitHeight);
		// Make smaller if the percents add up more then 100
		if (percentTotalValue > 100)
			availableHeightForPercents = availableHeightForPercents / (percentTotalValue / 100);
		
		//trace("percentTotalValue: " + percentTotalValue + " aHFP: " + availableHeightForPercents + " - " + explicitTotal + " - " + explicitHeight);
		var percentHeightValue:int = 0;
		var lastHeight:int = 0;
		var i:int;
		var item:DisplayObject;
		for (i = 0; i < children.length; i++)
		{
			item = children[i];
			// Set Y
			item.y = lastHeight + paddingTop;
			if (childrenPercentValues[i] > 0)
			{
				percentHeightValue = childrenPercentValues[i];
				// Set HEIGHT
				item.height = int(availableHeightForPercents * percentHeightValue / 100);
			}
			lastHeight += item.height + gap;
			
			// Set X
			item.x = paddingLeft;
			// Set WIDTH
			item.width = explicitWidth - paddingLeft - paddingRight;
			//trace("lastHeight : " + lastHeight);
		}
	}
}
}