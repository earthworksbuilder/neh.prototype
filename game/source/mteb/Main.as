package mteb
{
	import flash.display.Sprite;
	import flash.events.Event;

	import mteb.data.DataLocator;
	import mteb.data.time.Time;
	import mteb.view.LayerLocator;
	import mteb.view.Updatable;


	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#FFFFFF", quality="LOW")]
	public class Main extends Sprite
	{
		protected var layers:Vector.<Updatable> = new <Updatable>[];
		protected var time:Time;


		public function Main()
		{
			initialize();
		}

		protected function addLayer(value:Updatable):void
		{
			addChild(value.displayObject);
			layers.push(value);
		}

		protected function initialize():void
		{
			time = DataLocator.getInstance().time;

			const layerLocator:LayerLocator = LayerLocator.getInstance();
			addLayer(layerLocator.scene);
			addLayer(layerLocator.debug); // needs to be last so on top

			addEventListener(Event.ENTER_FRAME, onFrame);
		}

		protected function onFrame(event:Event):void
		{
			time.tock();
			var s:Number = time.secondsElapsed;

			var n:uint = layers.length;
			for (var i:uint = 0; i < n; i++)
				layers[i].update(s);
		}
	}
}
