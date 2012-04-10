package mteb.view.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.command.SignalBus;
	import mteb.command.signals.AzimuthChanged;
	import mteb.data.map.ICompass;


	public class UiLayer extends Sprite implements ISignalReceiver
	{
		protected const textField:TextField = new TextField();


		public function UiLayer()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

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

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			addChild(textField);
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = true;
			textField.backgroundColor = 0x666666;
			textField.textColor = 0x000000;

			textField.text = "Azimuth: - - - -";

			debug(this, "ui layer added to stage");
		}

		protected function onAzimuthChanged(compass:ICompass):void
		{
			textField.text = "Azimuth: " + compass.currentAzimuth.toFixed(2);
		}
	}
}
