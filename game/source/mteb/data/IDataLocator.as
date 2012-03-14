package mteb.data
{
	import mteb.data.input.IOrientationTransform;
	import mteb.data.map.IMap;
	import mteb.data.stats.IStats;
	import mteb.data.time.ITime;


	public interface IDataLocator
	{
		function get look():IOrientationTransform;

		function get map():IMap;

		function get stats():IStats;

		function get time():ITime;
	}
}
