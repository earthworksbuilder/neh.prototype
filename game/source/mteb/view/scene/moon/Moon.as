package mteb.view.scene.moon
{
	import away3d.entities.Mesh;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.ArtifactChanged;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.view.scene.compass.CompassLightEnum;


	public class Moon implements IMoon, ISignalReceiver
	{

		protected static const _geo:MoonGeometry = new MoonGeometry();

		protected var _state:MoonStateEnum = MoonStateEnum.WAITING;


		public function Moon()
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(ArtifactChanged, this);
		}

		public function get geometry():Mesh
		{
			return _geo as Mesh;
		}

		public function get radius():Number
		{
			return _geo.radius;
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is ArtifactChanged):
					onArtifactChanged(authority as ICompassLightStateProvider);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		public function get state():MoonStateEnum
		{
			return _state;
		}

		protected function onArtifactChanged(authority:ICompassLightStateProvider):void
		{
			if (authority.pointState == CompassLightEnum.ACTIVATED)
				debug(this, "onArtifactChanged() - activate moon!");
		}
	}
}
