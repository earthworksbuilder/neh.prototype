package mteb.view.ui
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.StageResized;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;


	public final class UiLayer extends Sprite implements ISignalReceiver
	{
		protected var heading:HeadingDisplay;
		protected var timeControl:TimeControl;
		protected var mapControl:MapControl;


		public function UiLayer()
		{
			super();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(StageResized, this);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is StageResized):
					onStageResized(authority as Stage);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			heading = new HeadingDisplay();
			addChild(heading);

			timeControl = new TimeControl();
			addChild(timeControl);

			mapControl = new MapControl();
			addChild(mapControl);

			onStageResized(stage);

			debug(this, "ui layer ready...");
			const dataLocator:IDataLocator = DataLocator.getInstance();
			dataLocator.mcp.onUiLayerReady();
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
