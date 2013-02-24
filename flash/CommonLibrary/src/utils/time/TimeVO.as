package utils.time
{
	public class TimeVO{
		
		public var days:int;
		public var hours:int;
		public var minutes:int;
		public var seconds:int;
		
		public function TimeVO(days:int,hours:int,minutes:int,seconds:int) {
			this.days = days;
			this.hours = hours;
			this.minutes = minutes;
			this.seconds = seconds;
		}
		
		
		public function format(showDays:Boolean,showHours:Boolean,showMinutes:Boolean,showSeconds:Boolean):String
		{
			var array:Array = [];
			if(showDays)
			{
				array.push(days<10?'0'+days:days);
			}
			if(showHours)
			{
				
				array.push(hours<10?'0'+hours:hours);
			}
			if(showMinutes)
			{
				array.push(minutes<10?'0'+minutes:minutes);
			}
			if(showSeconds)
			{
				array.push(seconds<10?'0'+seconds:seconds);
			}
			
			return array.join(': ');
		}
	}
	
}