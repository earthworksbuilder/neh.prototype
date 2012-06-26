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

	import mteb.control.SignalBus;
	import mteb.control.signals.StageResized;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;
	import mteb.view.ILayerLocator;
	import mteb.view.LayerLocator;


	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#FFFFFF", quality="LOW")]
	public class Main extends Sprite
	{

		protected const stageResized:IProtectedSignal = new StageResized();


		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			initialize();
		}

		protected function initialize():void
		{
			// notify mcp that initialization has commenced
			const data:IDataLocator = DataLocator.getInstance();
			data.mcp.onInitializationStarted();

			// register signals
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(stageResized as ISignal);

			// connect event driven data to events
			addEventListener(Event.ENTER_FRAME, data.time.onFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, data.look.onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, data.look.onKeyUp);
			stage.addEventListener(Event.RESIZE, onStageResized);

			// add display object layers to stage
			const layers:ILayerLocator = LayerLocator.getInstance();
			addChild(layers.scene.displayObject);
			addChild(layers.ui);
			addChild(layers.debug.displayObject); // needs to be last so on top

			// connect debug stats monitor to 3d view
			layers.debug.view3D = layers.scene.view3D;

			// kick things off by loading the map
			data.map.load("nodes/nodes.xml");
		}

		protected function onStageResized(event:Event):void
		{
			stageResized.send(stage);
		}
	}
}
