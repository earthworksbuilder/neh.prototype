package mteb.control.gamestate
{


	public final class CompassStateEnum
	{
		private var _label:String = "";


		public function CompassStateEnum(label:String)
		{
			_label = label;
		}

		public function toString():String
		{
			return _label;
		}
	}
}
