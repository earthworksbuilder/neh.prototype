package mteb.view.scene.compass
{


	public class CompassLightEnum
	{
		public static const DISABLED:CompassLightEnum = new CompassLightEnum("DISABLED");
		public static const ENABLED:CompassLightEnum = new CompassLightEnum("ENABLED");
		public static const ON:CompassLightEnum = new CompassLightEnum("ON");

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
