package mteb.view.scene.compass
{
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.AzimuthChanged;
	import mteb.control.signals.FrameEntered;
	import mteb.control.signals.RiseEnded;
	import mteb.control.signals.RiseStarted;
	import mteb.control.signals.SetEnded;
	import mteb.control.signals.SetStarted;
	import mteb.data.map.AzimuthTable;
	import mteb.data.map.ICompass;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.data.time.ITime;


	public class CompassControl extends ObjectContainer3D implements ISignalReceiver
	{

		protected const compassGeo:CompassGeometry = new CompassGeometry();
		protected const textureSprite:CompassSprite = new CompassSprite();


		public function CompassControl()
		{
			super();
			initialize();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(AzimuthChanged, this);
			signalBus.addReceiver(FrameEntered, this);
			signalBus.addReceiver(RiseStarted, this);
			signalBus.addReceiver(RiseEnded, this);
			signalBus.addReceiver(SetStarted, this);
			signalBus.addReceiver(SetEnded, this);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is AzimuthChanged):
					onAzimuthChanged(authority as ICompass);
					break;

				case (signal is FrameEntered):
					onFrameEntered(authority as ITime);
					break;

				case (signal is RiseStarted):
				case (signal is RiseEnded):
					onRisePointChanged(authority as ICompassLightStateProvider);
					break;

				case (signal is SetStarted):
				case (signal is SetEnded):
					onSetPointChanged(authority as ICompassLightStateProvider);
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
			rotationY = compass.currentAzimuth - AzimuthTable.northMaxRise;
			compassGeo.rotationY = -1 * compass.currentAzimuth;
		}

		protected function onFrameEntered(time:ITime):void
		{
			textureSprite.animate(time.secondsElapsed);
			compassGeo.texture = textureSprite.texture;
		}

		protected function onRisePointChanged(authority:ICompassLightStateProvider):void
		{
			debug(this, "onRisePointChanged() - change state of moonpoint {0} to {1}", authority.pointIndex, authority.pointState);
			textureSprite.changeRisePointState(authority.pointIndex, authority.pointState);
		}

		protected function onSetPointChanged(authority:ICompassLightStateProvider):void
		{
			debug(this, "onSetPointChanged() - change state of moonpoint {0} to {1}", authority.pointIndex, authority.pointState);
			textureSprite.changeSetPointState(authority.pointIndex, authority.pointState);
		}
	}
}
