package mteb.view.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.AzimuthChanged;
	import mteb.data.map.IAzimuthProvider;


	public class HeadingDisplay extends Sprite implements ISignalReceiver
	{
		protected const textField:TextField = new TextField();


		public function HeadingDisplay()
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
					onAzimuthChanged(authority as IAzimuthProvider);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		protected function initialize():void
		{
			addChild(textField);

			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = true;
			textField.backgroundColor = 0x666666;

			const tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.size = 14; //px
			textField.setTextFormat(tf);

			textField.text = "Azimuth: - - - -";
		}

		protected function onAzimuthChanged(compass:IAzimuthProvider):void
		{
			textField.text = "Azimuth: " + compass.currentAzimuth.toFixed(2);
		}
	}
}
