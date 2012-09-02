package mteb.data.time
{


	public interface ITime extends IFrameDriven
	{
		function get framesElapsed():uint;
		function get multiplier():Number;
		function set multiplier(value:Number):void;
		function get secondsElapsed():Number;
		function get secondsElapsedScaled():Number;
		function get secondsTotal():Number;
		function get secondsTotalScaled():Number;
	}
}
