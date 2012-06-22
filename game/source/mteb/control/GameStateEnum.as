package mteb.control
{


	public class GameStateEnum
	{
		public static const INITIALIZING:GameStateEnum = new GameStateEnum("INITIALIZING");
		public static const NODE_TRAVELING:GameStateEnum = new GameStateEnum("NODE_TRAVELING");
		public static const NODE_ARRIVED:GameStateEnum = new GameStateEnum("NODE_ARRIVED");
		public static const LOADING:GameStateEnum = new GameStateEnum("LOADING");
		public static const STARTED:GameStateEnum = new GameStateEnum("STARTED");
		public static const WAITING:GameStateEnum = new GameStateEnum("WAITING");

		private var _label:String = "";


		public function GameStateEnum(label:String)
		{
			_label = label;
		}

		public function toString():String
		{
			return _label;
		}
	}
}
