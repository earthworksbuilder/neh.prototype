package mteb.view.ui
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.PreferencesChanged;
	import mteb.control.signals.StageResized;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;
	import mteb.data.config.IConfig;


	public final class UiLayer extends Sprite implements ISignalReceiver
	{
		protected var heading:HeadingDisplay;
		protected var timeControl:TimeControl;
		protected var mapControl:MapControl;
		protected var messageControl:MessageControl;


		public function UiLayer()
		{
			super();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(StageResized, this);
			signalBus.addReceiver(PreferencesChanged, this);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is StageResized):
					onStageResized(authority as Stage);
					break;

				case (signal is PreferencesChanged):
					onPreferencesChanged(authority as IConfig);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			mouseEnabled = false;
			mouseChildren = true;

			heading = new HeadingDisplay();
			heading.mouseEnabled = false;
			heading.mouseChildren = false;
			addChild(heading);

			timeControl = new TimeControl();
			timeControl.mouseEnabled = true;
			addChild(timeControl);
			timeControl.visible = false;

			mapControl = new MapControl();
			mapControl.mouseEnabled = true;
			addChild(mapControl);

			messageControl = new MessageControl();
			messageControl.mouseEnabled = false;
			messageControl.mouseChildren = false;
			addChild(messageControl);

			onStageResized(stage);

			debug(this, "ui layer ready...");
			const dataLocator:IDataLocator = DataLocator.getInstance();
			dataLocator.mcp.onUiLayerReady();
		}

		protected function onPreferencesChanged(config:IConfig):void
		{
			timeControl.visible = config.showTimeControl;
		}

		protected function onStageResized(stage:Stage):void
		{
			debug(this, "onStageResized() - adjusting to new dimensions: {0}x{1}", stage.stageWidth, stage.stageHeight);

			heading.x = 0;
			heading.y = stage.stageHeight - heading.height;

			timeControl.x = (stage.stageWidth * .5) - (timeControl.width * .5);
			timeControl.y = stage.stageHeight - timeControl.height;

			mapControl.x = stage.stageWidth - (mapControl.width / 2);
			mapControl.y = stage.stageHeight - (mapControl.height / 2);
		}
	}
}
