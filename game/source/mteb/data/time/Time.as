package mteb.data.time
{
	import flash.utils.getTimer;

	import pixeldroid.signals.IProtectedSignal;


	public class Time
	{
		public const tick:IProtectedSignal = new TickSignal();
		protected var elapsed:Number;

		protected var lastTick:int;


		public function Time()
		{
		}

		public function get secondsElapsed():Number
		{
			return elapsed;
		}

		public function tock():void
		{
			var now:int = getTimer();
			elapsed = (lastTick ? (now - lastTick) : now) * .001; // seconds elapsed
			lastTick = now;

			tick.send(this);
		}
	}
}
