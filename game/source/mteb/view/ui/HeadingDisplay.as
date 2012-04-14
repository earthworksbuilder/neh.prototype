package mteb.view.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.command.SignalBus;
	import mteb.command.signals.AzimuthChanged;
	import mteb.data.map.ICompass;


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
					onAzimuthChanged(authority as ICompass);
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

		protected function onAzimuthChanged(compass:ICompass):void
		{
			textField.text = "Azimuth: " + compass.currentAzimuth.toFixed(2);
		}
	}
}
