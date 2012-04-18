package mteb.data.time
{
	import flash.events.Event;
	import flash.utils.getTimer;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;

	import mteb.command.SignalBus;
	import mteb.command.signals.FrameEntered;


	public class Time implements ITime
	{

		protected var elapsed:Number;
		protected const frameEntered:IProtectedSignal = new FrameEntered();
		protected var lastFrame:int;
		protected var totalFrames:uint;
		protected var _multiplier:Number = 5 * 1000;


		public function Time()
		{
			totalFrames = 0;

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(frameEntered as ISignal);
		}

		public function get framesElapsed():uint
		{
			return totalFrames;
		}

		public function get multiplier():Number  { return _multiplier; }

		public function set multiplier(value:Number):void  { _multiplier = value; }

		public function onFrame(event:Event):void
		{
			var now:int = getTimer();
			elapsed = (lastFrame ? (now - lastFrame) : now) * .001; // convert ms elapsed to seconds
			lastFrame = now;

			totalFrames++;

			frameEntered.send(this);
		}

		public function get secondsElapsed():Number
		{
			return elapsed;
		}

		public function get secondsElapsedScaled():Number
		{
			return elapsed * _multiplier;
		}
	}
}
