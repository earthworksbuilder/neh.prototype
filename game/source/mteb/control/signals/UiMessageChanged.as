package mteb.control.signals
{
	import pixeldroid.signals.ProtectedSignal;


	public class UiMessageChanged extends ProtectedSignal
	{
		public var message:String = "";


		public function UiMessageChanged()
		{
			super();
		}
	}
}
