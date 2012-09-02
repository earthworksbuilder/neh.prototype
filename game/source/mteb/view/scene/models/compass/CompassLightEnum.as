package mteb.view.scene.models.compass
{


	public final class CompassLightEnum
	{
		public static const LOCKED:CompassLightEnum = new CompassLightEnum("LOCKED");
		public static const UNLOCKED:CompassLightEnum = new CompassLightEnum("UNLOCKED");
		public static const ACTIVATED:CompassLightEnum = new CompassLightEnum("ACTIVATED");
		public static const CAPTURED:CompassLightEnum = new CompassLightEnum("CAPTURED");

		private var label:String;


		public function CompassLightEnum(label:String)
		{
			this.label = label;
		}

		public function toString():String
		{
			return label;
		}
	}
}
