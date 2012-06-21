package mteb.control.signals
{
	import pixeldroid.signals.ProtectedSignal;

	import mteb.data.map.ICompassLightStateProvider;
	import mteb.view.scene.compass.CompassLightEnum;


	public class HorizonEventSignal extends ProtectedSignal implements ICompassLightStateProvider
	{
		private var _pointIndex:uint;

		private var _pointState:CompassLightEnum;


		public function HorizonEventSignal()
		{
			super();
		}

		public function get pointIndex():uint
		{
			return _pointIndex;
		}

		public function set pointIndex(value:uint):void
		{
			_pointIndex = value;
		}

		public function get pointState():CompassLightEnum
		{
			return _pointState;
		}

		public function set pointState(value:CompassLightEnum):void
		{
			_pointState = value;
		}
	}
}
