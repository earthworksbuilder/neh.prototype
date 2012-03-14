package mteb.data.time
{


	public interface ITime extends IFrameDriven
	{
		function get framesElapsed():uint;
		function get secondsElapsed():Number;
	}
}
