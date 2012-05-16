package mteb.view.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.assets.Textures;
	import mteb.command.SignalBus;
	import mteb.command.signals.AzimuthChanged;
	import mteb.data.map.ICompass;


	public class MapControl extends Sprite implements ISignalReceiver
	{
		protected var map:Sprite;


		public function MapControl()
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
			map = Textures.nodeMap;
			addChild(map);
		}

		protected function onAzimuthChanged(compass:ICompass):void
		{
			map.rotation = -1 * (compass.currentAzimuth - 51.5);
		}
	}
}
