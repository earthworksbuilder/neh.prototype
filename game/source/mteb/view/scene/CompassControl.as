package mteb.view.scene
{
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.AzimuthChanged;
	import mteb.data.map.ICompass;


	public class CompassControl extends ObjectContainer3D implements ISignalReceiver
	{

		protected const compassGeo:ObjectContainer3D = new CompassGeometry();


		public function CompassControl()
		{
			super();
			initialize();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(AzimuthChanged, this);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is AzimuthChanged):
					onAzimuthChanged(authority as ICompass);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		protected function initialize():void
		{
			addChild(compassGeo);
			compassGeo.position = new Vector3D(0, -72, 128);
		}

		protected function onAzimuthChanged(compass:ICompass):void
		{
			// FIXME: hide this away inside ICompass
			const correctedAzimuth:Number = compass.currentAzimuth - 51.5;

			rotationY = correctedAzimuth;
			compassGeo.rotationY = -1 * correctedAzimuth;
		}
	}
}
