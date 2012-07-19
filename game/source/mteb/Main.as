package mteb
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.gamestate.GameStateEnum;
	import mteb.control.gamestate.IGameStateMachine;
	import mteb.control.signals.GameStateChanged;
	import mteb.control.signals.StageResized;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;
	import mteb.view.ILayerLocator;
	import mteb.view.LayerLocator;


	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#FFFFFF", quality="LOW")]
	public class Main extends Sprite implements ISignalReceiver
	{

		protected const stageResized:IProtectedSignal = new StageResized();


		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResized);

			// register signals
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(stageResized as ISignal);
			signalBus.addReceiver(GameStateChanged, this);

			const layers:ILayerLocator = LayerLocator.getInstance();
			addChild(layers.title);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is GameStateChanged):
					onGameStateChanged(authority as IGameStateMachine);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		protected function initialize():void
		{
			const data:IDataLocator = DataLocator.getInstance();
			const layers:ILayerLocator = LayerLocator.getInstance();

			// connect event driven data to events
			addEventListener(Event.ENTER_FRAME, data.time.onFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, data.look.onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, data.look.onKeyUp);

			// remove title and add display object layers to stage
			removeChild(layers.title);
			addChild(layers.scene.displayObject);
			addChild(layers.ui);
			addChild(layers.debug.displayObject); // needs to be last so on top

			// connect debug stats monitor to 3d view
			layers.debug.view3D = layers.scene.view3D;

			// kick things off by loading the map
			data.map.load("nodes/nodes.xml");
		}

		protected function onGameStateChanged(mcp:IGameStateMachine):void
		{
			if (mcp.state == GameStateEnum.INITIALIZING)
				initialize();
		}

		protected function onStageResized(event:Event):void
		{
			stageResized.send(stage);
		}
	}
}
