package mteb
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	import mteb.data.DataLocator;
	import mteb.view.LayerLocator;


	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#FFFFFF", quality="LOW")]
	public class Main extends Sprite
	{


		public function Main()
		{
			initialize();
		}

		protected function initialize():void
		{
			// connect event driven data to events
			const data:DataLocator = DataLocator.getInstance();
			addEventListener(Event.ENTER_FRAME, data.time.onFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, data.look.onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, data.look.onKeyUp);

			// add display object layers to stage
			const layers:LayerLocator = LayerLocator.getInstance();
			addChild(layers.scene);
			addChild(layers.debug); // needs to be last so on top
		}
	}
}
