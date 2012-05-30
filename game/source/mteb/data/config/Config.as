package mteb.data.config
{


	public class Config implements IConfig
	{
		protected var _showHotspots:Boolean = false;

		public function get showHotspots():Boolean  { return _showHotspots; }

		public function set showHotspots(value:Boolean):void  { _showHotspots = value; }
	}
}
