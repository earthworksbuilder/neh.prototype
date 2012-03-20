package mteb.data.map
{


	public class ActionTypeEnum
	{
		public static const NEXT_NODE:ActionTypeEnum = new ActionTypeEnum("NEXT_NODE");
		public static const NONE:ActionTypeEnum = new ActionTypeEnum("NONE");

		protected var _name:String = "";
		protected var _value:uint = 0;


		public function ActionTypeEnum(name:String)
		{
			_name = name;
		}

		public function toString():String  { return _name; }
	}
}
