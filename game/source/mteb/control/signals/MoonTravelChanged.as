package mteb.control.signals
{
	import pixeldroid.signals.ProtectedSignal;


	public class MoonTravelChanged extends ProtectedSignal
	{
		public var isMoving:Boolean = false;


		public function MoonTravelChanged()
		{
			super();
		}
	}
}
