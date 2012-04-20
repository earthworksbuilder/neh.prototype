package mteb.data.time
{
	import flash.events.Event;
	import flash.utils.getTimer;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.command.SignalBus;
	import mteb.command.signals.FrameEntered;
	import mteb.command.signals.TimeScaleChanged;


	public class Time implements ITime, ISignalReceiver
	{

		protected var elapsed:Number;
		protected const frameEntered:IProtectedSignal = new FrameEntered();
		protected var lastFrame:int;
		protected var totalFrames:uint;
		protected var _multiplier:Number = 1;


		public function Time()
		{
			totalFrames = 0;

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(frameEntered as ISignal);
			signalBus.addReceiver(TimeScaleChanged, this);
		}

		public function get framesElapsed():uint
		{
			return totalFrames;
		}

		public function get multiplier():Number  { return _multiplier; }

		public function set multiplier(value:Number):void
		{
			debug(this, "set multiplier() - new time multiplier: {0}", value);
			_multiplier = value;
		}

		public function onFrame(event:Event):void
		{
			var now:int = getTimer();
			elapsed = (lastFrame ? (now - lastFrame) : now) * .001; // convert ms elapsed to seconds
			lastFrame = now;

			totalFrames++;

			frameEntered.send(this);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is TimeScaleChanged):
					const timeScaleChanged:TimeScaleChanged = signal as TimeScaleChanged;
					multiplier = timeScaleChanged.scale;
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
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
