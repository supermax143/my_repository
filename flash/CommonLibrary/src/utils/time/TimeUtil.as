package utils.time
{
	public class TimeUtil
	{
		
		public function TimeUtil()
		{
			
		}
		
		public static function secondsToDHMS(seconds:Number):TimeVO//{d,h,m,s}
		{
			var days:int = int(seconds / 60 / 60 / 24);
			seconds -= days * 60 * 60 * 24;
			var hours:int = int(seconds / 60 / 60);
			seconds -= hours*60*60;
			var minutes:int = int(seconds/60);
			seconds -= minutes*60;
			return new TimeVO(days>0?days:0,hours>0?hours:0,minutes>0?minutes:0,seconds>0?seconds:0)
			
		}	
		
	}
	
	
}