package mteb.data
{
	import mteb.data.time.Time;
	import mteb.data.map.Map;
	import mteb.data.stats.Stats;


	public class DataLocator
	{
		private static var instance:DataLocator;

		public static function getInstance():DataLocator
		{
			return instance || (instance = new DataLocator(new SingletonKey()));
		}

		private var _map:Map;
		private var _stats:Stats;
		private var _time:Time;


		public function DataLocator(key:SingletonKey)
		{
			if (!key)
				throw new ArgumentError(SingletonKey.ERROR_MSG);
		}

		public function get map():Map  { return _map || (_map = new Map()); }

		public function get stats():Stats  { return _stats || (_stats = new Stats()); }

		public function get time():Time  { return _time || (_time = new Time()); }
	}
}


internal class SingletonKey
{
	public static const ERROR_MSG:String = "Please do not instantiate directly, use the getInstance() method instead.";
}
