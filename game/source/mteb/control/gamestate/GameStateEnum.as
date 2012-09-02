package mteb.control.gamestate
{


	public final class GameStateEnum
	{
		public static const TITLE_SHOWING:GameStateEnum = new GameStateEnum("TITLE_SHOWING");
		public static const INITIALIZING:GameStateEnum = new GameStateEnum("INITIALIZING");
		public static const WAITING_TO_LOAD:GameStateEnum = new GameStateEnum("WAITING_TO_LOAD");
		public static const WAITING_TO_SHOW:GameStateEnum = new GameStateEnum("WAITING_TO_SHOW");
		public static const NODE_TRAVELING:GameStateEnum = new GameStateEnum("NODE_TRAVELING");
		public static const NODE_ARRIVED:GameStateEnum = new GameStateEnum("NODE_ARRIVED");
		public static const LOADING:GameStateEnum = new GameStateEnum("LOADING");
		public static const STARTED:GameStateEnum = new GameStateEnum("STARTED");
		public static const WAITING:GameStateEnum = new GameStateEnum("WAITING");
		public static const MOON_PAUSED:GameStateEnum = new GameStateEnum("MOON_PAUSED");
		public static const UNLOCKING:GameStateEnum = new GameStateEnum("UNLOCKING");
		public static const ACTIVATING:GameStateEnum = new GameStateEnum("ACTIVATING");
		public static const CAPTURING:GameStateEnum = new GameStateEnum("CAPTURING");

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
