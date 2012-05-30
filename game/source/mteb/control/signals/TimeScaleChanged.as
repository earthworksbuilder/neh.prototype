package mteb.control.signals
{
	import pixeldroid.signals.ProtectedSignal;


	public class TimeScaleChanged extends ProtectedSignal
	{
		public var scale:Number = 1;


		public function TimeScaleChanged()
		{
			super();
		}
	}
}
