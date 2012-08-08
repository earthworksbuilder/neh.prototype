package mteb.view.scene.models.moon
{


	public class MoonStateEnum
	{

		public static const WAITING:MoonStateEnum = new MoonStateEnum("WAITING");
		public static const ACTIVATED:MoonStateEnum = new MoonStateEnum("ACTIVATED");
		public static const TRAVELING:MoonStateEnum = new MoonStateEnum("TRAVELING");

		private var label:String;


		public function MoonStateEnum(label:String)
		{
			this.label = label;
		}

		public function toString():String
		{
			return label;
		}
	}
}
