package mteb.data.map
{


	public class ActionTypeEnum
	{
		public static const JUMP_TO_NODE:ActionTypeEnum = new ActionTypeEnum("JUMP_TO_NODE");
		public static const MAP_PICK_NODE:ActionTypeEnum = new ActionTypeEnum("MAP_PICK_NODE");
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
