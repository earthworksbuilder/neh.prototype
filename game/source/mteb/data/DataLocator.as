package mteb.data
{
	import mteb.control.gamestate.IGameStateMachine;
	import mteb.control.gamestate.MCP;
	import mteb.data.config.Config;
	import mteb.data.config.IConfig;
	import mteb.data.input.IOrientationTransform;
	import mteb.data.input.UserOrientationTransform;
	import mteb.data.map.IMap;
	import mteb.data.map.Map;
	import mteb.data.player.IInventory;
	import mteb.data.player.IStats;
	import mteb.data.player.Inventory;
	import mteb.data.player.Stats;
	import mteb.data.time.ITime;
	import mteb.data.time.Time;


	public final class DataLocator implements IDataLocator
	{
		private static var instance:IDataLocator;

		public static function getInstance():IDataLocator
		{
			return instance || (instance = new DataLocator(new SingletonKey()));
		}

		private var _config:IConfig;

		private var _look:IOrientationTransform;

		private var _map:IMap;

		private var _mcp:IGameStateMachine;

		private var _inventory:IInventory;

		private var _stats:IStats;

		private var _time:ITime = new Time(); // no lazy loading for this one


		public function DataLocator(key:SingletonKey)
		{
			if (!key)
				throw new ArgumentError(SingletonKey.ERROR_MSG);
		}

		public function get config():IConfig  { return _config || (_config = new Config); }

		public function get inventory():IInventory  { return _inventory || (_inventory = new Inventory()); }

		public function get look():IOrientationTransform  { return _look || (_look = new UserOrientationTransform()); }

		public function get map():IMap  { return _map || (_map = new Map()); }

		public function get mcp():IGameStateMachine  { return _mcp || (_mcp = new MCP()); }

		public function get stats():IStats  { return _stats || (_stats = new Stats()); }

		public function get time():ITime  { return _time; }
	}
}


internal class SingletonKey
{
	public static const ERROR_MSG:String = "Please do not instantiate directly, use the getInstance() method instead.";
}
