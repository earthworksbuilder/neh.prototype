package mteb.view.title
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.assets.Sounds;
	import mteb.assets.UiElements;
	import mteb.control.SignalBus;
	import mteb.control.signals.StageResized;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;


	public class TitleLayer extends Sprite implements ISignalReceiver
	{
		private var titleScreen:Bitmap;
		private var sound:SoundChannel;


		public function TitleLayer()
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

			addChild(titleScreen = UiElements.titleScreen);
			addEventListener(MouseEvent.CLICK, onClicked);

			sound = Sounds.drumAndFlute.play();

			onStageResized(stage);
			debug(this, "title layer added to stage");
		}

		protected function onClicked(event:MouseEvent):void
		{
			debug(this, "onClicked() - sending request for new game to start");
			sound.stop();
			const data:IDataLocator = DataLocator.getInstance();
			data.mcp.onNewGameRequested();
		}

		protected function onStageResized(stage:Stage):void
		{
			debug(this, "onStageResized() - adjusting to new dimensions: {0}x{1}", stage.stageWidth, stage.stageHeight);
			titleScreen.width = stage.stageWidth;
			titleScreen.height = stage.stageHeight;
		}
	}
}
