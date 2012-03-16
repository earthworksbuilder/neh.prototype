package mteb.view.scene
{


	public class SkyBoxFaceEnum
	{
		public static const POSX:SkyBoxFaceEnum = new SkyBoxFaceEnum("POSX", 0);
		public static const NEGX:SkyBoxFaceEnum = new SkyBoxFaceEnum("NEGX", 1);
		public static const POSY:SkyBoxFaceEnum = new SkyBoxFaceEnum("POSY", 2);
		public static const NEGY:SkyBoxFaceEnum = new SkyBoxFaceEnum("NEGY", 3);
		public static const POSZ:SkyBoxFaceEnum = new SkyBoxFaceEnum("POSZ", 4);
		public static const NEGZ:SkyBoxFaceEnum = new SkyBoxFaceEnum("NEGZ", 5);

		public static var faces:Vector.<SkyBoxFaceEnum> = new <SkyBoxFaceEnum>[POSX, NEGX, POSY, NEGY, POSZ, NEGZ];

		public static function fromString(value:String):SkyBoxFaceEnum
		{
			var face:SkyBoxFaceEnum;

			switch (value)
			{
				case POSX.toString():
					face = POSX;
					break;
				case NEGX.toString():
					face = NEGX;
					break;
				case POSY.toString():
					face = POSY;
					break;
				case NEGY.toString():
					face = NEGY;
					break;
				case POSZ.toString():
					face = POSZ;
					break;
				case NEGZ.toString():
					face = NEGZ;
					break;
			}

			return face;
		}

		public static function fromUint(value:int):SkyBoxFaceEnum  { return faces[value]; }

		protected var _name:String = "";
		protected var _value:uint = 0;


		public function SkyBoxFaceEnum(name:String, value:uint)
		{
			_name = name;
			_value = value;
		}

		public function get index():uint  { return _value; }

		public function toString():String  { return _name; }

		public function valueOf():Object  { return _value; }
		;
	}
}
